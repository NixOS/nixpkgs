{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "inscriptis";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    rev = "refs/tags/${version}";
    hash = "sha256-9KEkXcdZ7USXfyIXGDrp4p4kJTzF2q30fvOccxF1hBU=";
  };

  propagatedBuildInputs = [
    lxml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "inscriptis"
  ];

  meta = with lib; {
    description = "HTML to text converter";
    homepage = "https://github.com/weblyzard/inscriptis";
    changelog = "https://github.com/weblyzard/inscriptis/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
