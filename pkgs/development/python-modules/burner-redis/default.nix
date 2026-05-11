{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,

  pytest-asyncio,
  redis,
}:

buildPythonPackage (finalAttrs: {
  pname = "burner-redis";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prefectlabs";
    repo = "burner-redis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-soXwXxo8vVGEEM5iDNFa86zlPA+e74b+AS9diUoOdME=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-0qdmcoRje7OkHnGhO8CaR/g38yL9K8Jc+1KjfW4xPTQ=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "burner_redis" ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook

    pytest-asyncio
    redis
  ];

  meta = {
    description = "Embedded, in-process Redis-compatible database";
    homepage = "https://github.com/prefectlabs/burner-redis";
    downloadPage = "https://github.com/prefectlabs/burner-redis/releases";
    changelog = "https://github.com/prefectlabs/burner-redis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
