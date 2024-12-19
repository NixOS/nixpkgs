{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  pytest-benchmark,
  pytestCheckHook,
  setuptools-scm,
  six,
}:

let
  automat = buildPythonPackage rec {
    version = "24.8.1";
    format = "pyproject";
    pname = "automat";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-s0Inz2P2MluK0jme3ngGdQg+Q5sgwyPTdjc9juYwbYg=";
    };

    nativeBuildInputs = [ setuptools-scm ];

    propagatedBuildInputs = [
      six
      attrs
    ];

    nativeCheckInputs = [
      pytest-benchmark
      pytestCheckHook
    ];

    # escape infinite recursion with twisted
    doCheck = false;

    passthru.tests = {
      check = automat.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = with lib; {
      homepage = "https://github.com/glyph/Automat";
      description = "Self-service finite-state machines for the programmer on the go";
      mainProgram = "automat-visualize";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
in
automat
