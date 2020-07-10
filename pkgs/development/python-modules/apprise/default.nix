{ lib, buildPythonPackage, fetchPypi
, Babel, requests, requests_oauthlib, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aacdd54640a9c66d1c84c8f4390f63feb5a7a8741867a6b451f82ff74c8c792c";
  };

  nativeBuildInputs = [ Babel ];

  propagatedBuildInputs = [
    requests requests_oauthlib six click markdown pyyaml
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
