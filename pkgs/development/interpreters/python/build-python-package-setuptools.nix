# This function provides specific bits for building a setuptools-based Python package.

{ lib
, python
, bootstrapped-pip
, setuptools
, wheel
}:

{ buildInputs ? []
# passed to "python setup.py build_ext"
# https://github.com/pypa/pip/issues/881
,  setupPyBuildFlags ? []
# Execute before shell hook
, preShellHook ? ""
# Execute after shell hook
, postShellHook ? ""
, ... } @ attrs:

attrs // {
  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    ${python.interpreter} -m setuptools.launch setup.py ${lib.optionalString (setupPyBuildFlags != []) ("build_ext " + (lib.concatStringsSep " " setupPyBuildFlags))} bdist_wheel
    runHook postBuild
  '';

  installCheckPhase = attrs.checkPhase or ''
    runHook preCheck
    ${python.interpreter} -m setuptools.launch setup.py test
    runHook postCheck
  '';

  buildInputs = buildInputs ++ [ setuptools wheel ];

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
      export PYTHONPATH="$tmp_path/${python.sitePackages}:$PYTHONPATH"
      mkdir -p $tmp_path/${python.sitePackages}
      ${bootstrapped-pip}/bin/pip install -e . --prefix $tmp_path >&2
    fi
    ${postShellHook}
  '';
}
