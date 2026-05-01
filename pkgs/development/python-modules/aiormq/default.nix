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
  version = "9.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiormq";
    tag = version;
    hash = "sha256-GFeOwjSQ1+nxP9hgNoELoEInTmhhO0JnNeoe2qfWNcg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "uv_build>=0.10.4,<0.11.0" uv_build
  '';

  pythonRelaxDeps = [ "pamqp" ];

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
