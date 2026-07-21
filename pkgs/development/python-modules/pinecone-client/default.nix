{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  hatchling,
  orjson,
  pinecone-plugin-assistant,
  pinecone-plugin-interface,
  python-dateutil,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pinecone-client";
  version = "8.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pinecone-io";
    repo = "pinecone-python-client";
    tag = "v${version}";
    hash = "sha256-VfoSW17Bx/eFlnSxUiQZsfY/y210/sKIF5df/kb2kTc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    certifi
    orjson
    pinecone-plugin-assistant
    pinecone-plugin-interface
    python-dateutil
    typing-extensions
    urllib3
  ];

  pythonImportsCheck = [ "pinecone" ];

  meta = {
    description = "Pinecone python client";
    homepage = "https://www.pinecone.io/";
    changelog = "https://github.com/pinecone-io/pinecone-python-client/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
