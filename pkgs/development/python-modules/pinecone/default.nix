{
  lib,
  buildPythonPackage,
  buildPackages,
  fetchFromGitHub,
  httpx,
  msgspec,
  orjson,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "pinecone";
  version = "10.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pinecone-io";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-P/lDCfXCmLqQUxkWbH75zKq5XdocLvGIqjiE4dXCpQg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ZCalE4tarPxQ5PpmyK4cQJ6Fet6ljR5m7ha7oaUZZHs=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  env.PROTOC = "${lib.getExe buildPackages.protobuf}";

  dependencies = [
    httpx
    msgspec
    orjson
  ];

  pythonImportsCheck = [ "pinecone" ];

  meta = {
    description = "Pinecone Python SDK";
    homepage = "https://www.pinecone.io/";
    changelog = "https://github.com/pinecone-io/python-sdk/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
