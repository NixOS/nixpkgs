{ lib, buildPythonPackage, fetchPypi
, Babel, requests, requests_oauthlib, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox, gntp, sleekxmpp
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.8.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "024db00c6a80dbc8c9038b2de211c9fd32963046612882f3f54ad78930f3e0f7";
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
