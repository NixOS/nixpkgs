{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, python-jose
, httmock
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    rev = version;
    sha256 = "sha256-YWDj/dLN72XMxDXpSPQvkxHF5xJ15xWJjw3vtfmxlwo=";
  };

  propagatedBuildInputs = [
    requests
    python-jose
  ];

  checkInputs = [
    httmock
  ];

  checkPhase = ''
    python -m unittest discover
  '';

  pythonImportsCheck = [ "keycloak" ];

  meta = with lib; {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
