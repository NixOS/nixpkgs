{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  loguru,
  numpy,
  poetry-core,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests,
  pandas,
  setuptools,
  tqdm,
  typing-extensions,
  pinecone-plugin-interface,
  pinecone-plugin-inference,
  urllib3,
  googleapis-common-protos,
  lz4,
  protobuf,
  grpcio,
}:

buildPythonPackage rec {
  pname = "pinecone-client";
  version = "5.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pinecone-io";
    repo = "pinecone-python-client";
    tag = "v${version}";
    hash = "sha256-5BCjqcJ+xCTTF/Q+PrgNV4Y/GcT2cfNqvY1ydUL6EZ8=";
  };

  build-system = [
    setuptools
    poetry-core
  ];

  dependencies = [
    dnspython
    loguru
    numpy
    python-dateutil
    pinecone-plugin-interface
    pinecone-plugin-inference
    pyyaml
    requests
    tqdm
    typing-extensions
    urllib3
  ];

  pythonImportsCheck = [ "pinecone" ];

  meta = {
    description = "Pinecone python client";
    homepage = "https://www.pinecone.io/";
    changelog = "https://github.com/pinecone-io/pinecone-python-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
