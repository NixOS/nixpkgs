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
  version = "10.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pinecone-io";
    repo = "pinecone-python-client";
    tag = "v${version}";
    hash = "sha256-DvCPMhuVDGO9Bidz07rUOBM5L91Q+GHUuiX7rxLoJwI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-qhH2TmnxfUpFzmTVqG4MihaqbEQiWAtV5WHspsLTdSo=";
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
