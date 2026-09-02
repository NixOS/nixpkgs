{
  lib,
  aiormq,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  uv-build,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aio-pika";
  version = "10.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aio-pika";
    tag = finalAttrs.version;
    hash = "sha256-IVFZyYogfwEGyu4oysh5XGxVBEzoMT4lKoJKtphm3kE=";
  };

  pythonRelaxDeps = [ "aiormq" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.26,<0.12" uv_build
  '';

  build-system = [ uv-build ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiormq
    yarl
  ];

  # Tests require running a RabbitMQ server.
  # They rely on having AMQP_URL set or running Docker.
  doCheck = false;

  pythonImportsCheck = [ "aio_pika" ];

  meta = {
    description = "AMQP 0.9 client designed for asyncio and humans";
    homepage = "https://github.com/mosquito/aio-pika";
    changelog = "https://github.com/mosquito/aio-pika/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
})
