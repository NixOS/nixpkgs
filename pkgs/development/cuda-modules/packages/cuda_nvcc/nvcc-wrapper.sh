#!@shell@
set -e
source @wrapperUtils@

# NVCC exports its computed profile to subprocesses. A nested compiler must
# start with its own SDK paths; caller options use -I/-L and NVCC_*_FLAGS.
unset INCLUDES SYSTEM_INCLUDES LIBRARIES

# NVCC selects its backend afresh; an enclosing driver's prepared request does not apply.
wrapperClear

# cc-wrapper and bintools-wrapper share their salt between compiler versions
# targeting the same CPU. Narrow their roles to this NVCC invocation so a
# native BUILD compiler cannot contribute dependency flags to a native HOST compiler.
for role in BUILD HOST TARGET; do
    marker="NIX_NVCC_TARGET_${role}_@suffixSalt@"
    export "NIX_CC_WRAPPER_TARGET_${role}_@ccSuffixSalt@=${!marker-}"
    export "NIX_BINTOOLS_WRAPPER_TARGET_${role}_@bintoolsSuffixSalt@=${!marker-}"
done

accumulateRoles
# Outside a stdenv activation, use the wrapper's own backend and the ordinary
# environment.
if (( ${#role_suffixes[@]} == 0 )); then
    role_suffixes=('')
    export NIX_NVCC_TARGET_HOST_@suffixSalt@=1
    export NIX_CC_WRAPPER_TARGET_HOST_@ccSuffixSalt@=1
    export NIX_BINTOOLS_WRAPPER_TARGET_HOST_@bintoolsSuffixSalt@=1
fi

# Recover caller inputs before a nested invocation selects its roles. Keep
# intervening caller edits, including an explicit empty or unset value.
restoreProjectedVar NVCC_CCBIN NIX_NVCC_CCBIN
for role in _FOR_BUILD '' _FOR_TARGET; do
    restoreProjectedVar "NIX_LDFLAGS_AFTER$role" "NIX_NVCC_LDFLAGS_AFTER$role"
done
mangleVarSingle NVCC_CCBIN "${role_suffixes[@]}"

# NVCC_CCBIN is a default: explicit --compiler-bindir arguments (including
# those in the caller's NVCC_PREPEND_FLAGS) retain NVCC's normal precedence.
exportProjectedVar NVCC_CCBIN "${wrapper_NVCC_CCBIN:-@hostCompiler@}" NIX_NVCC_CCBIN
# Keep a caller's basename override ahead of the packaged fallback.
export PATH="@nvccPrefix@/nix-support/bin${PATH:+:$PATH}:@cc@/bin"

# Append after every active role's caller flags. The ordinary backend linker
# consumes these flags; nvlink continues to receive only library search paths.
ldAfterVariable="NIX_LDFLAGS_AFTER${role_suffixes[-1]}"
exportProjectedVar "$ldAfterVariable" "${!ldAfterVariable-} -rpath @driverRunpath@" "NIX_NVCC_LDFLAGS_AFTER${role_suffixes[-1]}"
unset ldAfterVariable

libraryFlags=()
# The backend wrapper already reads NIX_CFLAGS_COMPILE and NIX_LDFLAGS.
# NVCC also invokes nvlink directly, so its device linker needs the same -L
# search paths. Other host linker options remain the backend's responsibility.
# Initialize privately: an overridden backend must load its own defaults,
# rather than inherit the packaged bintools' flags and initialization marker.
ldFlagsText="$(
    set -e
    source @bintoolsFlags@
    printf '%s\n' "$wrapper_NIX_LDFLAGS_BEFORE $wrapper_NIX_LDFLAGS $wrapper_NIX_LDFLAGS_AFTER"
)"
read -r -d '' -a ldFlags <<< "$ldFlagsText" || true
unset ldFlagsText
for ((i=0; i<${#ldFlags[@]}; i++)); do
    case "${ldFlags[i]}" in
        -L|--library-path) libraryFlags+=("-L" "${ldFlags[++i]}") ;;
        -L?*) libraryFlags+=("${ldFlags[i]}") ;;
        --library-path=*) libraryFlags+=("-L" "${ldFlags[i]#*=}") ;;
    esac
done
# The profile places dependency paths after all caller flag channels and before
# packaged defaults. Recompute this private input even in nested invocations.
export NIX_NVCC_LIBRARIES="${libraryFlags[*]}"
[[ -n ${NIX_CUDA_DONT_COMPRESS_FATBINS-} ]] || set -- -Xfatbin=-compress-all "$@"
# CMake identifies NVIDIA from the "nvcc:" prefix in --version output.
# Use the absolute public name: NVCC also locates its profile through argv[0],
# and another CUDA version may appear first on PATH.
exec -a @nvccPrefix@/bin/nvcc @nvcc@ "$@"
