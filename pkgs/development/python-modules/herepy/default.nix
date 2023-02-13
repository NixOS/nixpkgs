{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "herepy";
  version = "3.5.8";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "abdullahselek";
    repo = "HerePy";
    rev = "refs/tags/${version}";
    hash = "sha256-BwuH3GxEXiIFFM0na8Jhgp7J5TPW41/u89LWf+EprG4=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "herepy"
  ];

  meta = with lib; {
    description = "Library that provides a Python interface to the HERE APIs";
    homepage = "https://github.com/abdullahselek/HerePy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
