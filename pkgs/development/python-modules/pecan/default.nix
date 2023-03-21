{ lib
, fetchPypi
, buildPythonPackage
, logutils
, mako
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
    hash = "sha256-SbJV5wHD8UYWBfWw6PVPDCGSLXhF1BTCTdZAn+aV1VA=";
  };

  propagatedBuildInputs = [
    logutils
    mako
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
    # tests fail with sqlalchemy 2.0
  ] ++ lib.optionals (lib.versionAtLeast sqlalchemy.version "2.0") [
    # The 'sqlalchemy.orm.mapper()' function is removed as of SQLAlchemy
    # 2.0.  Use the 'sqlalchemy.orm.registry.map_imperatively()` method
    # of the ``sqlalchemy.orm.registry`` class to perform classical
    # mapping.
    # https://github.com/pecan/pecan/issues/143
    "--deselect=pecan/tests/test_jsonify.py::TestJsonifySQLAlchemyGenericEncoder::test_result_proxy"
    "--deselect=pecan/tests/test_jsonify.py::TestJsonifySQLAlchemyGenericEncoder::test_row_proxy"
    "--deselect=pecan/tests/test_jsonify.py::TestJsonifySQLAlchemyGenericEncoder::test_sa_object"
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
