{
  lib,
  aiormq,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  yarl,
}:

buildPythonPackage rec {
  pname = "aio-pika";
  version = "9.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aio-pika";
    tag = version;
    hash = "sha256-N5MjFIolMRTTn4aV1NskBwonB/8FSuEZETumUrAa02Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.26,<0.10.0" uv_build
  '';

  build-system = [ uv-build ];

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
    changelog = "https://github.com/mosquito/aio-pika/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
