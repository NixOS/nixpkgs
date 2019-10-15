{ lib, buildPythonPackage, fetchPypi
, Babel, requests, requests_oauthlib, six, click, markdown, pyyaml
, pytestrunner, coverage, flake8, mock, pytest, pytestcov, tox
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02apbzckj158995k9ls0gr1m9hfk7nw3ck0bp7k41srl5wdys72i";
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
