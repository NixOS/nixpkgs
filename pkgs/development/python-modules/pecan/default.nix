{ lib
, fetchPypi
, buildPythonPackage
, logutils
, mako
<<<<<<< HEAD
, webob
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, webtest
, pythonOlder
, pytestCheckHook
, genshi
, gunicorn
, jinja2
<<<<<<< HEAD
, sqlalchemy
, virtualenv
, setuptools
=======
, six
, sqlalchemy
, virtualenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pecan";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-YGMnLV+GB3P7tLSyrhsJ2oyVQGLvhxFQwGz9sjkdk1U=";
=======
    hash = "sha256-SbJV5wHD8UYWBfWw6PVPDCGSLXhF1BTCTdZAn+aV1VA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    logutils
    mako
<<<<<<< HEAD
    webob
    setuptools
=======
    webtest
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    genshi
    gunicorn
    jinja2
    sqlalchemy
    virtualenv
<<<<<<< HEAD
    webtest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pytestFlagsArray = [
    "--pyargs pecan"
<<<<<<< HEAD
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
