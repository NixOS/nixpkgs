{ lib
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, pythonOlder
, requests
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "ondilo";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "JeromeHXP";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BieWdPakQts0QxzQzJYlP6a7ieZ40rAyYqhy8zEvU38=";
  };

  propagatedBuildInputs = [
    oauthlib
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ondilo"
  ];

  meta = with lib; {
    description = "Python package to access Ondilo ICO APIs";
    homepage = "https://github.com/JeromeHXP/ondilo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
