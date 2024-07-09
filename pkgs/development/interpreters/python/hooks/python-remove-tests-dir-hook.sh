# Clean up top-level tests directory in site-package installation.
echo "Sourcing python-remove-tests-dir-hook"

pythonRemoveTestsDir() {
    echo "Executing pythonRemoveTestsDir"

    rm -rf $out/@pythonSitePackages@/tests
    rm -rf $out/@pythonSitePackages@/test

    echo "Finished executing pythonRemoveTestsDir"
}

if [ -z "${dontUsePythonRemoveTestsDir-}" ]; then
    postFixupHooks+=(pythonRemoveTestsDir)
fi
