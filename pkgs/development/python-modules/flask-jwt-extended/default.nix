{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  flask,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-jwt-extended";
  version = "4.7.1";
  pyproject = true;

  src = fetchPypi {
    pname = "flask_jwt_extended";
    inherit version;
    hash = "sha256-gIXWdXUFtvMpGiY4yE0gfo8K0N5mLR9Gqi935ligyXY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    pyjwt
    python-dateutil
    werkzeug
  ];

  optional-dependencies.asymmetric_crypto = [ cryptography ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "flask_jwt_extended" ];

  meta = {
    changelog = "https://github.com/vimalloc/flask-jwt-extended/releases/tag/${version}";
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerschtli ];
  };
}
