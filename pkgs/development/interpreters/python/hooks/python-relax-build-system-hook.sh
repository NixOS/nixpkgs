# shellcheck shell=bash

# Setup hook that relaxes or removes version constraints from Python build
# system requirements declared in pyproject.toml [build-system].requires.
#
# Example usage in a derivation:
#
#   { ..., python3Packages, ... }:
#
#   python3Packages.buildPythonPackage {
#     ...
#     # Relax specific build requirements (strips version constraints):
#     # e.g., uv_build>=0.9.20,<0.10.0 -> uv_build
#     pythonRelaxBuildSystem = [ "uv_build" ];
#     # Relax all build requirement version constraints:
#     pythonRelaxBuildSystem = true;
#     # Remove specific build requirements entirely:
#     pythonRemoveBuildSystem = [ "wheel" ];
#     ...
#   }
#
# This hook modifies pyproject.toml.

echo "Sourcing python-relax-build-system-hook.sh"

pythonRelaxBuildSystemHook() {
    local -a args=()

    if [[ -z "${pythonRelaxBuildSystem[*]-}" ]] || [[ "${pythonRelaxBuildSystem}" == 0 ]]; then
        :
    elif [[ "${pythonRelaxBuildSystem}" == 1 ]]; then
        args+=(--relax-all)
    else
        # shellcheck disable=SC2048
        for dep in ${pythonRelaxBuildSystem[*]}; do
            args+=(--relax "$dep")
        done
    fi

    if [[ -n "${pythonRemoveBuildSystem[*]-}" ]] && [[ "${pythonRemoveBuildSystem}" != 0 ]]; then
        # shellcheck disable=SC2048
        for dep in ${pythonRemoveBuildSystem[*]-}; do
            args+=(--remove "$dep")
        done
    fi

    if [[ ${#args[@]} -eq 0 ]]; then
        return
    fi

    @pythonInterpreter@ "@script@" "${args[@]}"
}

preBuild+=" pythonRelaxBuildSystemHook"
