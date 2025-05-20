{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  googleapis-common-protos,
  grpcio,
  protobuf,
  semver,
  pygments,
  pyopenssl,
  typing-extensions,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "dazl";
  version = "8.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digital-asset";
    repo = "dazl-client";
    tag = "v${version}";
    hash = "sha256-JeAdg+OW3Zd275zIYDmfBaF7RWEb+sLQ7xFIl67L2R8=";
  };

  pythonRelaxDeps = [
    "grpcio"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    googleapis-common-protos
    grpcio
    protobuf
    semver
    typing-extensions
  ];

  optional-dependencies = {
    pygments = [ pygments ];
    tls-testing = [ pyopenssl ];
  };

  pythonImportsCheck = [ "dazl" ];

  # daml: command not found
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = {
    description = "High-level Ledger API client for Daml ledgers";
    license = lib.licenses.asl20;
    homepage = "https://github.com/digital-asset/dazl-client";
    changelog = "https://github.com/digital-asset/dazl-client/releases/tag/v${version}";
  };
}
