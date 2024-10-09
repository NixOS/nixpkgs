{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  flask,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-jwt-extended";
  version = "4.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-JWT-Extended";
    inherit version;
    hash = "sha256-khXQWpQT04VXZLzWcDXnWBnSOvL6+2tVGX61ozE/37I=";
  };

  propagatedBuildInputs = [
    flask
    pyjwt
    python-dateutil
    werkzeug
  ];

  optional-dependencies.asymmetric_crypto = [ cryptography ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "flask_jwt_extended" ];

  meta = with lib; {
    changelog = "https://github.com/vimalloc/flask-jwt-extended/releases/tag/${version}";
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
