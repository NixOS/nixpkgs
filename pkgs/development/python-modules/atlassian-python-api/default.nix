{ lib
, buildPythonPackage
, fetchFromGitHub
, deprecated
, oauthlib
, requests
, requests_oauthlib
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = version;
    sha256 = "sha256-J0/CtfBtOdWReKQS/VvOL/3r+j4zJfnv/ICIXepKUvc=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [ deprecated oauthlib requests requests_oauthlib six ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
