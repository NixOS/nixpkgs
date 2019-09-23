{ lib, buildPythonPackage, fetchPypi
, Babel, decorator, requests, requests_oauthlib, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zqnk255d311ibird08sv0c21fw1r1xhldhyx5lnl3ji1xkv9173";
  };

  nativeBuildInputs = [ Babel ];

  propagatedBuildInputs = [
    decorator requests requests_oauthlib six click markdown pyyaml
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
