#!@shell@
set -e
source @bintools@/nix-support/utils.bash

# NVCC exports its computed profile to subprocesses. A nested compiler must
# start with its own SDK paths; caller options use -I/-L and NVCC_*_FLAGS.
unset INCLUDES SYSTEM_INCLUDES LIBRARIES

# Another compiler may have initialized these internal caches for different
# roles or defaults. Rebuild them from the role inputs below; changing role
# markers alone would leave its already-projected flags in effect.
for variable in "${!NIX_@}"; do
    if [[ $variable == *_@ccSuffixSalt@ || $variable == *_@bintoolsSuffixSalt@ ]]; then
        unset "$variable"
    fi
done

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

# NVCC's backend variable is also a role input. A nested NVCC must recover the
# caller's input before selecting its own roles and default; an inherited
# wrapper projection is not a new caller override. Preserve intervening edits.
if [[ -v NIX_NVCC_CCBIN_PROJECTED && -v NVCC_CCBIN && $NVCC_CCBIN == "$NIX_NVCC_CCBIN_PROJECTED" ]]; then
    if [[ -v NIX_NVCC_CCBIN_ORIGINAL ]]; then
        export NVCC_CCBIN="$NIX_NVCC_CCBIN_ORIGINAL"
    else
        unset NVCC_CCBIN
    fi
fi
if [[ -v NVCC_CCBIN ]]; then
    export NIX_NVCC_CCBIN_ORIGINAL="$NVCC_CCBIN"
else
    unset NIX_NVCC_CCBIN_ORIGINAL
fi
mangleVarSingle NVCC_CCBIN "${role_suffixes[@]}"

# NVCC_CCBIN is a default: explicit --compiler-bindir arguments (including
# those in the caller's NVCC_PREPEND_FLAGS) retain NVCC's normal precedence.
export NVCC_CCBIN="${NVCC_CCBIN_@bintoolsSuffixSalt@:-@hostCompiler@}"
export NIX_NVCC_CCBIN_PROJECTED="$NVCC_CCBIN"
# These projections are private to this invocation, even when another NVCC
# package shares the same bintools wrapper.
unset NVCC_CCBIN_@bintoolsSuffixSalt@
# Keep a caller's basename override ahead of the packaged fallback.
export PATH="@nvccPrefix@/nix-support/bin${PATH:+:$PATH}:@cc@/bin"

libraryFlags=()
# The backend wrapper already reads NIX_CFLAGS_COMPILE and NIX_LDFLAGS.
# NVCC also invokes nvlink directly, so its device linker needs the same -L
# search paths. Other host linker options remain the backend's responsibility.
# Initialize privately: an overridden backend must load its own defaults,
# rather than inherit the packaged bintools' flags and initialization marker.
ldFlagsText="$(
    set -e
    source @bintools@/nix-support/add-flags.sh
    printf '%s\n' "$NIX_LDFLAGS_BEFORE_@bintoolsSuffixSalt@ $NIX_LDFLAGS_@bintoolsSuffixSalt@ $NIX_LDFLAGS_AFTER_@bintoolsSuffixSalt@"
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
