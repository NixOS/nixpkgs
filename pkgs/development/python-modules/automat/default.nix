{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  pytest-benchmark,
  pytestCheckHook,
  setuptools,
}:

let
  automat = buildPythonPackage rec {
    version = "25.4.16";
    pyproject = true;
    pname = "automat";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-ABdZGlR3Bm6Q0msOaW3cFDuq/Ye1iM+sgQC8a+ljTeA=";
    };

    build-system = [
      setuptools
      hatch-vcs
    ];

    nativeCheckInputs = [
      pytest-benchmark
      pytestCheckHook
    ];

    pytestFlags = [ "--benchmark-disable" ];

    # escape infinite recursion with twisted
    doCheck = false;

    passthru.tests = {
      check = automat.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = {
      homepage = "https://github.com/glyph/Automat";
      description = "Self-service finite-state machines for the programmer on the go";
      mainProgram = "automat-visualize";
      license = lib.licenses.mit;
      maintainers = [ ];
    };
  };
in
automat
