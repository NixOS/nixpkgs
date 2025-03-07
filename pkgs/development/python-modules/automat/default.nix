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
    version = "22.10.0";
    format = "setuptools";
    pname = "automat";

    src = fetchPypi {
      pname = "Automat";
      inherit version;
      hash = "sha256-5WvrhO2tGdzBHTDo2biV913ute9elrhKRnBms7hLsE4=";
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
      maintainers = with maintainers; [ ];
    };
  };
in
automat
