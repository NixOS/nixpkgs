{ lib, buildPythonPackage, fetchPypi
, Babel, decorator, requests, requests_oauthlib, oauthlib, urllib3, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15xv7lhivjhgsaw5j30w1fkk8y33r8nkr2hwp8z1jmsxhdv9l03y";
  };

  nativeBuildInputs = [ Babel ];

  propagatedBuildInputs = [
    decorator requests requests_oauthlib oauthlib urllib3 six click markdown pyyaml
  ];

  checkInputs = [
    pytestrunner coverage flake8 mock pytest pytestcov tox
  ];

  meta = with lib; {
    homepage = "https://github.com/caronc/apprise";
    description = "Push Notifications that work with just about every platform!";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
