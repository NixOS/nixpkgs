{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "inscriptis";
  version = "2.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    rev = "refs/tags/${version}";
    sha256 = "sha256-grsyHqt7ahiNsYKcZN/c5cJaag/nTWTBcaHaXnW1SpU=";
  };

  propagatedBuildInputs = [
    lxml
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inscriptis" ];

  meta = with lib; {
    description = "inscriptis - HTML to text converter";
    homepage = "https://github.com/weblyzard/inscriptis";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
