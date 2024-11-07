# Clean up top-level tests directory in site-package installation.
# shellcheck shell=bash

echo "Sourcing python-remove-tests-dir-hook"

pythonRemoveTestsDir() {
    echo "Executing pythonRemoveTestsDir"

    # shellcheck disable=SC2154
    rm -rf "$out/@pythonSitePackages@/tests"
    rm -rf "$out/@pythonSitePackages@/test"

    echo "Finished executing pythonRemoveTestsDir"
}

if [ -z "${dontUsePythonRemoveTestsDir-}" ]; then
    postFixupHooks+=(pythonRemoveTestsDir)
fi
