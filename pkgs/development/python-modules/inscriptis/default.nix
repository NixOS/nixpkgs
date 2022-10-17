{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "inscriptis";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    rev = version;
    sha256 = "sha256-an/FTbujN2VnTYa0wngM8ugV1LNHJWM32RVqIbaW0KY=";
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
