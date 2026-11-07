{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  uv-build,
  boto3,
  sqlalchemy,
  peewee,
  pillow,
  pytestCheckHook,
  moto,
}:
buildPythonPackage (finalAttrs: {
  pname = "fastapi-storages";
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "smithyhq";
    repo = "fastapi-storages";
    tag = finalAttrs.version;
    hash = "sha256-HOirLcBnhB3Q1Fry2erjSxJ4uNlvxyZkB8tiEN4ZnlY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.9.17,<0.10.0' 'uv_build'
  '';

  build-system = [ uv-build ];

  optional-dependencies = {
    s3 = [ boto3 ];
    sqlalchemy = [ sqlalchemy ];
    peewee = [ peewee ];
    image = [ pillow ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    moto
  ]
  ++ lib.flatten (lib.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "fastapi_storages" ];
  meta = {
    description = "File storage backends for FastAPI applications";
    homepage = "https://github.com/smithyhq/fastapi-storages";
    changelog = "https://github.com/smithyhq/fastapi-storages/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
