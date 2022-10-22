{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, python-jose
, httmock
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    rev = version;
    sha256 = "sha256-XCOfzzUs0K5/peprgpEXY2pX6wYOF7hg9ec1XPEYHCI=";
  };

  propagatedBuildInputs = [
    requests
    python-jose
  ];

  checkInputs = [
    unittestCheckHook
    httmock
  ];

  pythonImportsCheck = [ "keycloak" ];

  meta = with lib; {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
