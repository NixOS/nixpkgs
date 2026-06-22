# Setup hook for storing dist folder (wheels/sdists) in a separate output
# shellcheck shell=bash

echo "Sourcing python-catch-conflicts-hook.sh"

pythonOutputDistPhase() {
    echo "Executing pythonOutputDistPhase"
    if [[ -d dist ]]; then
        # shellcheck disable=SC2154
        mv "dist" "$dist"
    else
        cat >&2 <<EOF
The build contains no ./dist directory.
If this project is not setuptools-based, pass

  format = "other";

to buildPythonApplication/buildPythonPackage or another appropriate value as described here:

  https://nixos.org/manual/nixpkgs/stable/#buildpythonpackage-function
EOF
        false
    fi
    echo "Finished executing pythonOutputDistPhase"
}

appendToVar preFixupPhases pythonOutputDistPhase
