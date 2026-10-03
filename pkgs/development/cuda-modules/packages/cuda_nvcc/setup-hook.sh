# shellcheck shell=bash
# Register this particular wrapper immediately: other wrappers also source
# role.bash and replace its functions with their own substitutions.
source @nvccPrefix@/nix-support/role.bash

_nvccSetup() {
    [[ -z ${strictDeps-} ]] || (( hostOffset < 0 )) || return 0
    local targetOffset="$targetOffset"
    # Non-strict builds use the ordinary unsuffixed compiler environment.
    [[ -n ${strictDeps-} ]] || targetOffset=0
    getTargetRoleWrapper

    # Register the backend's dependency collectors without activating its tools.
    # Each wrapper owns its callbacks; flags still share ordinary per-role NIX_*
    # variables, including when the enclosing project uses stdenvNoCC.
    source @bintools@/nix-support/add-env-hooks.sh
    source @cc@/nix-support/add-env-hooks.sh

    # Let the ordinary compiler choose its default first. NoCC still needs the
    # backend's default before build phases invoke NVCC.
    local hardeningFallback
    printf -v hardeningFallback '[[ -v NIX_HARDENING_ENABLE ]] || NIX_HARDENING_ENABLE=%q; export NIX_HARDENING_ENABLE' @defaultHardeningFlags@
    postHooks+=("$hardeningFallback")

    # Discover the compiler here; its wrapper owns the backend default.
    local role_post
    getTargetRole
    local cudacxx="CUDACXX${role_post}"
    export "${cudacxx}=${!cudacxx:-@nvccPrefix@/bin/nvcc}"
    if [[ -z $role_post && -z ${CUDAToolkit_ROOT-} ]]; then
        export CUDAToolkit_ROOT=@nvccPrefix@
    fi
    local cudaHostCxx="CUDAHOSTCXX${role_post}"
    # Defined-but-empty makes legacy FindCUDA defer to NVCC instead of adding
    # -ccbin for the project's C compiler. Modern CMake also defers when empty.
    export "${cudaHostCxx}=${!cudaHostCxx-}"

    # Legacy FindCUDA searches this before PATH; it does not use CUDACXX.
    # A BUILD compiler may appear earlier on PATH than the HOST compiler.
    if [[ -z $role_post && -z ${CUDA_BIN_PATH-} ]]; then
        export CUDA_BIN_PATH=@nvccPrefix@/bin
    fi

    export NIX_CUDA_DONT_COMPRESS_FATBINS="${dontCompressCudaFatbins-${dontCompressFatbin-}}"
    # Structured attributes may supply an array, while NVCC reads a scalar.
    local flags="${NVCC_PREPEND_FLAGS[*]-}"
    unset -v NVCC_PREPEND_FLAGS
    export NVCC_PREPEND_FLAGS="$flags"
}
_nvccSetup
unset -f _nvccSetup
