{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, six
, astroid
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mlTBFPAsepSA1WVQkyVGo/H+cdigLxvHzNDuPuNc9NU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    astroid
    pytestCheckHook
  ];

  disabledTests = [
    # Test is currently failing on Hydra, works locally
    "test_slices"
  ];

  disabledTestPaths = [
    # incompatible with astroid 2.11.0, pins <= 2.5.3
    "tests/test_astroid.py"
  ];

  pythonImportsCheck = [ "asttokens" ];

  meta = with lib; {
    homepage = "https://github.com/gristlabs/asttokens";
    description = "Annotate Python AST trees with source text and token information";
    license = licenses.asl20;
    maintainers = with maintainers; [ leenaars ];
  };
}
