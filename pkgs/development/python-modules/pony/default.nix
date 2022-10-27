{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ponyorm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yATIsX2nKsW5DBwg9/LznQqf+XPY3q46WZut18Sr0v0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests are outdated
    "test_exception_msg"
    "test_method"
  ];

  pythonImportsCheck = [
    "pony"
  ];

  meta = with lib; {
    description = "Library for advanced object-relational mapping";
    homepage = "https://ponyorm.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ d-goldin xvapx ];
  };
}
