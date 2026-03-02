{
  lib,
  apispec,
  asgiref,
  buildPythonPackage,
  fetchFromGitHub,
  flask-httpauth,
  flask-marshmallow,
  flask-sqlalchemy,
  flask,
  marshmallow,
  marshmallow-dataclass,
  openapi-spec-validator,
  pydantic,
  pytest-cov-stub,
  pytestCheckHook,
  python-dotenv,
  pyyaml,
  setuptools,
  webargs,
}:

buildPythonPackage (finalAttrs: {
  pname = "apiflask";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apiflask";
    repo = "apiflask";
    tag = finalAttrs.version;
    hash = "sha256-1nWA2PDgTG++AA0pJeGDiSQyRqLRGfDuzRwfDl8RKl0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apispec
    flask
    flask-httpauth
    flask-marshmallow
    flask-sqlalchemy
    marshmallow
    marshmallow-dataclass
    pydantic
    webargs
  ]
  ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    async = [ asgiref ];
    dotenv = [ python-dotenv ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    openapi-spec-validator
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "apiflask" ];

  meta = {
    description = "Lightweight Python web API framework";
    homepage = "https://github.com/apiflask/apiflask";
    changelog = "https://github.com/apiflask/apiflask/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
