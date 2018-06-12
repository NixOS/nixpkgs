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
, pytest
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
  version = "0.6.0";

  disabled = !isPy27;

  # There is no need to fix mock. https://github.com/mitodl/pylti/pull/48
  postPatch = ''
    substituteInPlace setup.py --replace "mock==1.0.1" "mock"
  '';

  propagatedBuildInputs = [ httplib2 oauth oauth2 semantic-version ];
  checkInputs = [
    flask httpretty oauthlib pyflakes pytest pytestcache pytestcov covCore
    pytestflakes pytestpep8 sphinx mock
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3203c5d0d8a527c092518d82d312757c036055ff628023985ab615ef471e602";
  };

  meta = {
    description = "Implementation of IMS LTI interface that works with edX";
    homepage = "https://github.com/mitodl/pylti";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
  };
}