{ lib, buildPythonPackage, fetchPypi
, Babel, requests, requests_oauthlib, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox, gntp, sleekxmpp
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18a65c5917bf7f2d48bb557bf0879e49c5293b4c0e9809328387ae09338ae37b";
  };

  nativeBuildInputs = [ Babel ];

  propagatedBuildInputs = [
    requests requests_oauthlib six click markdown pyyaml
  ];

  checkInputs = [
    pytestrunner coverage flake8 mock pytest pytestcov tox gntp sleekxmpp
  ];

  meta = with lib; {
    homepage = "https://github.com/caronc/apprise";
    description = "Push Notifications that work with just about every platform!";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
