# This function provides specific bits for building a setuptools-based Python package.

{ lib
, python
}:

{
# passed to "python setup.py build_ext"
# https://github.com/pypa/pip/issues/881
  setupPyBuildFlags ? []
# Execute before shell hook
, preShellHook ? ""
# Execute after shell hook
, postShellHook ? ""
, ... } @ attrs:

let
  # use setuptools shim (so that setuptools is imported before distutils)
  # pip does the same thing: https://github.com/pypa/pip/pull/3265
  setuppy = ./run_setup.py;

in attrs // {
  # we copy nix_run_setup over so it's executed relative to the root of the source
  # many project make that assumption
  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    cp ${setuppy} nix_run_setup
    ${python.pythonForBuild.interpreter} nix_run_setup ${lib.optionalString (setupPyBuildFlags != []) ("build_ext " + (lib.concatStringsSep " " setupPyBuildFlags))} bdist_wheel
    runHook postBuild
  '';

  installCheckPhase = attrs.checkPhase or ''
    runHook preCheck
    ${python.pythonForBuild.interpreter} nix_run_setup test
    runHook postCheck
  '';

  # Python packages that are installed with setuptools
  # are typically distributed with tests.
  # With Python it's a common idiom to run the tests
  # after the software has been installed.
  doCheck = attrs.doCheck or true;

  shellHook = attrs.shellHook or ''
    ${preShellHook}
    if test -e setup.py; then
      tmp_path=$(mktemp -d)
      export PATH="$tmp_path/bin:$PATH"
      export PYTHONPATH="$tmp_path/${python.pythonForBuild.sitePackages}:$PYTHONPATH"
      mkdir -p $tmp_path/${python.pythonForBuild.sitePackages}
      ${python.pythonForBuild.pkgs.bootstrapped-pip}/bin/pip install -e . --prefix $tmp_path >&2
    fi
    ${postShellHook}
  '';
}
