# This function provides specific bits for building a setuptools-based Python package.

{ lib
, python
}:

{
# Global options passed to "python setup.py"
  setupPyGlobalFlags ? []
# Build options passed to "build_ext"
# https://github.com/pypa/pip/issues/881
# Rename to `buildOptions` because it is not setuptools specific?
, setupPyBuildFlags ? []
# Execute before shell hook
, preShellHook ? ""
# Execute after shell hook
, postShellHook ? ""
, ... } @ attrs:

let
  pipGlobalFlagsString = lib.concatMapStringsSep " " (option: "--global-option ${option}") setupPyGlobalFlags;
  pipBuildFlagsString = lib.concatMapStringsSep " " (option: "--build-option ${option}") setupPyBuildFlags;
in attrs // {
  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    mkdir -p dist
    echo "Creating a wheel..."
    ${python.pythonForBuild.interpreter} -m pip wheel --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist ${pipGlobalFlagsString} ${pipBuildFlagsString} .
    echo "Finished creating a wheel..."
    runHook postBuild
  '';

  installCheckPhase = ''
    runHook preCheck
    echo "No checkPhase defined. Either provide a checkPhase or disable tests in case tests are not available."; exit 1
    runHook postCheck
  '';

  # With Python it's a common idiom to run the tests
  # after the software has been installed.
  doCheck = attrs.doCheck or true;

  shellHook = attrs.shellHook or ''
    ${preShellHook}
    # Long-term setup.py should be dropped.
    if [ -e pyproject.toml ]; then
      tmp_path=$(mktemp -d)
      export PATH="$tmp_path/bin:$PATH"
      export PYTHONPATH="$tmp_path/${python.pythonForBuild.sitePackages}:$PYTHONPATH"
      mkdir -p $tmp_path/${python.pythonForBuild.sitePackages}
      ${python.pythonForBuild.pkgs.bootstrapped-pip}/bin/pip install -e . --prefix $tmp_path >&2
    fi
    ${postShellHook}
  '';

}
