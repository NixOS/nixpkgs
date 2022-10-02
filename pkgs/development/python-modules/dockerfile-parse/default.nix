{ lib
, buildPythonPackage
, fetchPypi
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dockerfile-parse";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B+Ze7DE5eOh32oGYVYcLOuR/P6yUpAqWW57eEEhNrMU=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dockerfile_parse"
  ];

  disabledTests = [
    # python-dockerfile-parse.spec is not present
    "test_all_versions_match"
  ];

  meta = with lib; {
    description = "Library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
