{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonAtLeast
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jAe+KQu1nwNYiRWSHinopQACrK8s3F+g4BFPkXCfr6A=";
  };

  checkInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # python changed exception message format in 3.10, 3.10 not yet supported
    "test_python_exception_matches"
  ];

  meta = with lib; {
    description = "A Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
  };
}
