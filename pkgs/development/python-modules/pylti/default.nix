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
, pytest-cov
, covCore
, pytest-flakes
, sphinx
, mock
, chalice
, isPy27
}:

buildPythonPackage rec {
  pname = "pylti";
  version = "0.7.0";
  format = "setuptools";

  disabled = !isPy27;

  # There is no need to fix mock. https://github.com/mitodl/pylti/pull/48
  postPatch = ''
    substituteInPlace setup.py --replace "mock==1.0.1" "mock"
  '';

  propagatedBuildInputs = [ httplib2 oauth oauth2 semantic-version ];
  nativeCheckInputs = [
    flask httpretty oauthlib pyflakes pytest pytestcache pytest-cov covCore
    pytest-flakes sphinx mock chalice
  ];

  src = fetchPypi {
    pname = "PyLTI";
    inherit version;
    sha256 = "80938a235b1ab390f6889a95237d087ea7adde5cc50fcae9c80c49898e8ee78e";
  };

  meta = {
    description = "Implementation of IMS LTI interface that works with edX";
    homepage = "https://github.com/mitodl/pylti";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
  };
}
