#! @shell@
# NOTE: This wrapper is derived from cc-wrapper.sh, and is hopefully somewhat
# diffable with the original, so changes can be merged if necessary.
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

cc_wrapper="${NIX_CC:-@default_cc_wrapper@}"

source $cc_wrapper/nix-support/utils.bash

expandResponseParams "$@"

# Check if we should wrap this Swift invocation at all, and how. Specifically,
# there are some internal tools we don't wrap, plus swift-frontend doesn't link
# and doesn't understand linker flags. This follows logic in
# `lib/DriverTool/driver.cpp`.
prog=@prog@
progName="$(basename "$prog")"
firstArg="${params[0]:-}"
isFrontend=0
isRepl=0

# These checks follow `shouldRunAsSubcommand`.
if [[ "$progName" == swift ]]; then
    case "$firstArg" in
        "" | -* | *.* | */* | repl)
            ;;
        *)
            exec "swift-$firstArg" "${params[@]:1}"
            ;;
    esac
fi

# These checks follow the first part of `run_driver`.
#
# NOTE: The original function short-circuits, but we can't here, because both
# paths must be wrapped. So we use an 'isFrontend' flag instead.
case "$firstArg" in
    -frontend)
        isFrontend=1
        # Ensure this stays the first argument.
        params=( "${params[@]:1}" )
        extraBefore+=( "-frontend" )
        ;;
    -modulewrap)
        # Don't wrap this integrated tool.
        exec "$prog" "${params[@]}"
        ;;
    repl)
        isRepl=1
        params=( "${params[@]:1}" )
        ;;
    --driver-mode=*)
        ;;
    *)
        if [[ "$progName" == swift-frontend ]]; then
            isFrontend=1
        fi
        ;;
esac

# For many tasks, Swift reinvokes swift-driver, the new driver implementation
# written in Swift. It needs some help finding the executable, though, and
# reimplementing the logic here is little effort. These checks follow
# `shouldDisallowNewDriver`.
if [[
    $isFrontend = 0 &&
    -n "@swiftDriver@" &&
    -z "${SWIFT_USE_OLD_DRIVER:-}" &&
    ( "$progName" == "swift" || "$progName" == "swiftc" )
]]; then
    prog=@swiftDriver@
    # Driver mode must be the very first argument.
    extraBefore+=( "--driver-mode=$progName" )
    if [[ $isRepl = 1 ]]; then
        extraBefore+=( "-repl" )
    fi

    # Ensure swift-driver invokes the unwrapped frontend (instead of finding
    # the wrapped one via PATH), because we don't have to wrap a second time.
    export SWIFT_DRIVER_SWIFT_FRONTEND_EXEC="@swift@/bin/swift-frontend"

    # Ensure swift-driver can find the LLDB with Swift support for the REPL.
    export SWIFT_DRIVER_LLDB_EXEC="@swift@/bin/lldb"
fi

path_backup="$PATH"

# That @-vars are substituted separately from bash evaluation makes
# shellcheck think this, and others like it, are useless conditionals.
# shellcheck disable=SC2157
if [[ -n "@coreutils_bin@" && -n "@gnugrep_bin@" ]]; then
    PATH="@coreutils_bin@/bin:@gnugrep_bin@/bin"
fi

# Parse command line options and set several variables.
# For instance, figure out if linker flags should be passed.
# GCC prints annoying warnings when they are not needed.
isCxx=0
dontLink=$isFrontend

for p in "${params[@]}"; do
    case "$p" in
        -enable-cxx-interop | -enable-experimental-cxx-interop)
            isCxx=1 ;;
    esac
done

# NOTE: We don't modify these for Swift, but sourced scripts may use them.
cxxInclude=1
cxxLibrary=1
cInclude=1

linkType=$(checkLinkType "${params[@]}")

# Optionally filter out paths not refering to the store.
if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "$NIX_STORE" ]]; then
    kept=()
    nParams=${#params[@]}
    declare -i n=0
    while (( "$n" < "$nParams" )); do
        p=${params[n]}
        p2=${params[n+1]:-} # handle `p` being last one
        n+=1

        skipNext=false
        path=""
        case "$p" in
            -[IL]/*) path=${p:2} ;;
            -[IL]) path=$p2 skipNext=true ;;
        esac

        if [[ -n $path ]] && badPath "$path"; then
            skip "$path"
            $skipNext && n+=1
            continue
        fi

        kept+=("$p")
    done
    # Old bash empty array hack
    params=(${kept+"${kept[@]}"})
fi

# Flirting with a layer violation here.
if [ -z "${NIX_BINTOOLS_WRAPPER_FLAGS_SET_@suffixSalt@:-}" ]; then
    source @bintools@/nix-support/add-flags.sh
fi

# Put this one second so libc ldflags take priority.
if [ -z "${NIX_CC_WRAPPER_FLAGS_SET_@suffixSalt@:-}" ]; then
    source $cc_wrapper/nix-support/add-flags.sh
fi

if [[ "$isCxx" = 1 ]]; then
    if [[ "$cxxInclude" = 1 ]]; then
        NIX_CFLAGS_COMPILE_@suffixSalt@+=" $NIX_CXXSTDLIB_COMPILE_@suffixSalt@"
    fi
    if [[ "$cxxLibrary" = 1 ]]; then
        NIX_CFLAGS_LINK_@suffixSalt@+=" $NIX_CXXSTDLIB_LINK_@suffixSalt@"
    fi
fi

source $cc_wrapper/nix-support/add-hardening.sh

# Add the flags for the C compiler proper.
addCFlagsToList() {
    declare -n list="$1"
    shift

    for ((i = 1; i <= $#; i++)); do
        local val="${!i}"
        case "$val" in
            # Pass through using -Xcc, but also convert to Swift -I.
            # These have slightly different meaning for Clang, but Swift
            # doesn't have exact equivalents.
            -isystem | -idirafter)
                i=$((i + 1))
                list+=("-Xcc" "$val" "-Xcc" "${!i}" "-I" "${!i}")
                ;;
            # Simple rename.
            -iframework)
                i=$((i + 1))
                list+=("-Fsystem" "${!i}")
                ;;
            # Pass through verbatim.
            -I | -Fsystem)
                i=$((i + 1))
                list+=("${val}" "${!i}")
                ;;
            -I* | -L* | -F*)
                list+=("${val}")
                ;;
            # Pass through using -Xcc.
            *)
                list+=("-Xcc" "$val")
                ;;
        esac
    done
}
for i in ${NIX_SWIFTFLAGS_COMPILE:-}; do
    extraAfter+=("$i")
done
for i in ${NIX_SWIFTFLAGS_COMPILE_BEFORE:-}; do
    extraBefore+=("$i")
done
addCFlagsToList extraAfter $NIX_CFLAGS_COMPILE_@suffixSalt@
addCFlagsToList extraBefore ${hardeningCFlags[@]+"${hardeningCFlags[@]}"} $NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@

if [ "$dontLink" != 1 ]; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    addCFlagsToList extraAfter $(filterRpathFlags "$linkType" $NIX_CFLAGS_LINK_@suffixSalt@)

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS_@suffixSalt@ again).
    for i in $(filterRpathFlags "$linkType" $NIX_LDFLAGS_BEFORE_@suffixSalt@); do
        extraBefore+=("-Xlinker" "$i")
    done
    if [[ "$linkType" == dynamic && -n "$NIX_DYNAMIC_LINKER_@suffixSalt@" ]]; then
        extraBefore+=("-Xlinker" "-dynamic-linker=$NIX_DYNAMIC_LINKER_@suffixSalt@")
    fi
    for i in $(filterRpathFlags "$linkType" $NIX_LDFLAGS_@suffixSalt@); do
        if [ "${i:0:3}" = -L/ ]; then
            extraAfter+=("$i")
        else
            extraAfter+=("-Xlinker" "$i")
        fi
    done
    export NIX_LINK_TYPE_@suffixSalt@=$linkType
fi

# TODO: If we ever need to expand functionality of this hook, it may no longer
# be compatible with Swift. Right now, it is only used on Darwin to force
# -target, which also happens to work with Swift.
if [[ -e $cc_wrapper/nix-support/add-local-cc-cflags-before.sh ]]; then
    source $cc_wrapper/nix-support/add-local-cc-cflags-before.sh
fi

for ((i=0; i < ${#extraBefore[@]}; i++));do
    case "${extraBefore[i]}" in
    -target)
        i=$((i + 1))
        # On Darwin only, need to change 'aarch64' to 'arm64'.
        extraBefore[i]="${extraBefore[i]/aarch64-apple-/arm64-apple-}"
        # On Darwin, Swift requires the triple to be annotated with a version.
        # TODO: Assumes macOS.
        extraBefore[i]="${extraBefore[i]/-apple-darwin/-apple-macosx${MACOSX_DEPLOYMENT_TARGET:-11.0}}"
        ;;
    -march=*|-mcpu=*|-mfloat-abi=*|-mfpu=*|-mmode=*|-mthumb|-marm|-mtune=*)
        [[ i -gt 0 && ${extraBefore[i-1]} == -Xcc ]] && continue
        extraBefore=(
            "${extraBefore[@]:0:i}"
            -Xcc
            "${extraBefore[@]:i:${#extraBefore[@]}}"
        )
        i=$((i + 1))
        ;;
    esac
done

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if [ "$*" = -v ]; then
    extraAfter=()
    extraBefore=()
fi

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    # Old bash workaround, see ld-wrapper for explanation.
    echo "extra flags before to $prog:" >&2
    printf "  %q\n" ${extraBefore+"${extraBefore[@]}"}  >&2
    echo "original flags to $prog:" >&2
    printf "  %q\n" ${params+"${params[@]}"} >&2
    echo "extra flags after to $prog:" >&2
    printf "  %q\n" ${extraAfter+"${extraAfter[@]}"} >&2
fi

PATH="$path_backup"
# Old bash workaround, see above.

if (( "${NIX_CC_USE_RESPONSE_FILE:-@use_response_file_by_default@}" >= 1 )); then
    exec "$prog" @<(printf "%q\n" \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"})
else
    exec "$prog" \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"}
fi
