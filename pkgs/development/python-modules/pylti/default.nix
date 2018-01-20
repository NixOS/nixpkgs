{ lib
, buildPythonPackage
, fetchPypi
, httplib2
, oauth
, oauth2
, semantic-version
, flask
, httpretty
, oauthlib
, pyflakes
, pytest_27
, pytestcache
, pytestcov
, covCore
, pytestflakes
, pytestpep8
, sphinx
, mock
, isPy27
}:

buildPythonPackage rec {
  pname = "PyLTI";
  version = "0.4.1";

  disabled = !isPy27;

  # There is no need to fix mock. https://github.com/mitodl/pylti/pull/48
  postPatch = ''
    substituteInPlace setup.py --replace "mock==1.0.1" "mock"
  '';

  propagatedBuildInputs = [ httplib2 oauth oauth2 semantic-version ];
  checkInputs = [
    flask httpretty oauthlib pyflakes pytest_27 pytestcache pytestcov covCore
    pytestflakes pytestpep8 sphinx mock
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "076llj10j85zw3zq2gygx2pcfqi9rgcld5m4vq1iai1fk15x60fz";
  };

  meta = {
    description = "Implementation of IMS LTI interface that works with edX";
    homepage = "https://github.com/mitodl/pylti";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
  };
}