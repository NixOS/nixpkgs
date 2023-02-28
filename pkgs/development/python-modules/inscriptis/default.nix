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
  version = "2.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    rev = "refs/tags/${version}";
    hash = "sha256-grsyHqt7ahiNsYKcZN/c5cJaag/nTWTBcaHaXnW1SpU=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
