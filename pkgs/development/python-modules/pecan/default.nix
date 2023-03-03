{ lib
, fetchPypi
, buildPythonPackage
, logutils
, Mako
, webtest
, pythonOlder
, pytestCheckHook
, genshi
, gunicorn
, jinja2
, six
, sqlalchemy
, virtualenv
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SbJV5wHD8UYWBfWw6PVPDCGSLXhF1BTCTdZAn+aV1VA=";
  };

  propagatedBuildInputs = [
    logutils
    Mako
    webtest
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    genshi
    gunicorn
    jinja2
    sqlalchemy
    virtualenv
  ];

  pytestFlagsArray = [
    "--pyargs pecan"
  ];

  pythonImportsCheck = [
    "pecan"
  ];

  meta = with lib; {
    changelog = "https://pecan.readthedocs.io/en/latest/changes.html";
    description = "WSGI object-dispatching web framework";
    homepage = "https://www.pecanpy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ applePrincess ];
  };
}
