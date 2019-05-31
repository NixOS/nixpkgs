{ lib, buildPythonPackage, fetchPypi
, Babel, decorator, requests, requests_oauthlib, oauthlib, urllib3, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3c7922f7b80107620f541a6c16435485e7045771b3ecfb998deacee0eb90753";
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
