{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  loguru,
  numpy,
  poetry-core,
  python-dateutil,
  pyyaml,
  requests,
  setuptools,
  tqdm,
  typing-extensions,
  pinecone-plugin-assistant,
  pinecone-plugin-interface,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pinecone-client";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pinecone-io";
    repo = "pinecone-python-client";
    tag = "v${version}";
    hash = "sha256-4oj1TBVykWvPtmfdRUgRojTds9bCWj9XOrcNRzUspKA=";
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
    pinecone-plugin-assistant
    pinecone-plugin-interface
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
    changelog = "https://github.com/pinecone-io/pinecone-python-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
