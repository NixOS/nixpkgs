{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  pydantic,
  pydantic-settings,
  graphql-core,
  httpx,
  ujson,
  dulwich,
  whenever,
  netutils,
  tomli,
}:
buildPythonPackage (finalAttrs: {
  pname = "infrahub-sdk";
  version = "1.23.1";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "opsmill";
    repo = "infrahub-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GugwLYVC8wP/Ahcr9wtXqsHFvlUKDTlT7q9N4Ssrlbo=";
  };
  dependencies = [
    pydantic
    pydantic-settings
    graphql-core
    httpx
    ujson
    dulwich
    whenever
    netutils
    tomli
  ];
  build-system = [
    hatchling
    hatch-vcs
  ];
  # Upstream pins whenever<0.10.0; nixpkgs' whenever is 0.10.5.
  pythonRelaxDeps = [ "whenever" ];

  pythonImportsCheck = [ "infrahub_sdk" ];

  meta = {
    description = "Python client library and CLI to interact with the API of an Infrahub instance";
    homepage = "https://github.com/opsmill/infrahub-sdk-python";
    changelog = "https://github.com/opsmill/infrahub-sdk-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
