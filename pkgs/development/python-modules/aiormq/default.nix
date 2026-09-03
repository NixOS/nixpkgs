{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pamqp,
  uv-build,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiormq";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiormq";
    tag = version;
    hash = "sha256-pSiue6DS+YvU3OS3Kyxqt/duGhZaBaDnFqP5CJZTgzk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "uv_build>=0.10.4,<0.12" uv_build
  '';

  build-system = [ uv-build ];

  dependencies = [
    pamqp
    yarl
  ];

  # Tests require running a RabbitMQ server.
  # They rely on having AMQP_URL set or running Docker.
  doCheck = false;

  pythonImportsCheck = [ "aiormq" ];

  meta = {
    description = "AMQP 0.9.1 asynchronous client library";
    homepage = "https://github.com/mosquito/aiormq";
    changelog = "https://github.com/mosquito/aiormq/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
