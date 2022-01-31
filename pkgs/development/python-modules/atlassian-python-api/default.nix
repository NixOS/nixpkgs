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
  version = "3.18.1";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = version;
    sha256 = "09xvkbdfhkrdkn8axb6bhi7p12lm2z1z84rx1wksfw9mffqk90v9";
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
