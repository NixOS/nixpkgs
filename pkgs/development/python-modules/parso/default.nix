{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jAe+KQu1nwNYiRWSHinopQACrK8s3F+g4BFPkXCfr6A=";
  };

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # fails with python 3.10
    # https://github.com/davidhalter/parso/issues/192
    "test_python_errors"
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
  };
}
