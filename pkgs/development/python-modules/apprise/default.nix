{ lib, buildPythonPackage, fetchPypi
, Babel, requests, requests_oauthlib, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a26fa03c4b83f03f17e8f8fc0b94d5502a12dc2e39b48e93a0ab0fd93151a95";
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
