{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  objgraph,
  psutil,
  python,
  unittestCheckHook,
}:

let
  greenlet = buildPythonPackage rec {
    pname = "greenlet";
    version = "3.2.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-n03UtJRrFLs78Dj4Hh0uU1t9lPGypZ/boSk82cGgpNc=";
    };

    build-system = [ setuptools ];

    # tests in passthru, infinite recursion via objgraph/graphviz
    doCheck = false;

    nativeCheckInputs = [
      objgraph
      psutil
      unittestCheckHook
    ];

    preCheck = ''
      pushd ${placeholder "out"}/${python.sitePackages}
    '';

    unittestFlagsArray = [ "greenlet.tests" ];

    postCheck = ''
      popd
    '';

    passthru.tests.pytest = greenlet.overridePythonAttrs (_: {
      doCheck = true;
    });

    meta = with lib; {
      changelog = "https://github.com/python-greenlet/greenlet/blob/${version}/CHANGES.rst";
      homepage = "https://github.com/python-greenlet/greenlet";
      description = "Module for lightweight in-process concurrent programming";
      license = with licenses; [
        psfl # src/greenlet/slp_platformselect.h & files in src/greenlet/platform/ directory
        mit
      ];
    };
  };
in
greenlet
