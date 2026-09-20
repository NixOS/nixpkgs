# shellcheck shell=bash
# Register this particular wrapper immediately: other wrappers also source
# role.bash and replace its functions with their own substitutions.
source @nvccPrefix@/nix-support/role.bash

_nvccSetup() {
    [[ -z ${strictDeps-} ]] || (( hostOffset < 0 )) || return 0
    local targetOffset="$targetOffset"
    # Match the component collector's non-strict flattening.
    [[ -n ${strictDeps-} ]] || targetOffset=0
    getTargetRoleWrapper

    # Reuse the backend's collectors, including in stdenvNoCC. Run its hooks
    # in a subshell: tool selection, PATH changes and wrapper role markers
    # belong to NVCC's backend and must not affect the enclosing project.
    # Import the standard collectors under this NVCC output's own names:
    # compiler-specific definitions must not replace another role's callbacks.
    # Flags within each role still share the ordinary NIX_* variables.
    local registrations
    registrations="$(
        set -e
        exec {registrationFd}>&1 1>&2
        # Called by the sourced backend hooks.
        # shellcheck disable=SC2329
        addEnvHooks() {
            local offset="$1"
            shift
            local identity=@nvccPrefix@
            identity="${identity##*/}"
            identity="${identity%%-*}"
            local callback definition privateCallback
            for callback in "$@"; do
                definition="$(declare -f "$callback")"
                privateCallback="_nvcc_${identity}_${callback}"
                printf '%s%s\n' "$privateCallback" "${definition#"$callback"}" >&"$registrationFd"
                printf 'addEnvHooks %q %q\n' "$offset" "$privateCallback" >&"$registrationFd"
            done
        }
        source @bintools@/nix-support/setup-hook
        source @cc@/nix-support/setup-hook
        # Let the ordinary compiler finish choosing its default first. NoCC
        # still needs the backend's default before build phases invoke NVCC.
        printf -v hardeningFallback '[[ -v NIX_HARDENING_ENABLE ]] || NIX_HARDENING_ENABLE=%q; export NIX_HARDENING_ENABLE' "$NIX_HARDENING_ENABLE"
        printf 'postHooks+=(%q)\n' "$hardeningFallback" >&"$registrationFd"
    )"
    eval "$registrations"

    # Legacy FindCUDA adds an explicit -ccbin, so NVCC_CCBIN alone cannot
    # supply its default. Both discovery interfaces must name this backend.
    local role_post
    getTargetRole
    local cudaHostCxx="CUDAHOSTCXX${role_post}" nvccCcbin="NVCC_CCBIN${role_post}"
    export "${cudaHostCxx}=${!cudaHostCxx:-${!nvccCcbin:-@hostCompiler@}}"
    export "${nvccCcbin}=${!nvccCcbin:-${!cudaHostCxx}}"

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
