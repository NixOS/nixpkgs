{
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "pinecone-plugin-assistant";
  version = "1.8.0";

  pyproject = true;

  src = fetchPypi {
    pname = "pinecone_plugin_assistant";
    inherit version;
    hash = "sha256-joaCz/MPm66SQ7OEAhq6cckfTm7xZQ6dY+5kqrg8uoc=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
  ];

  pythonRelaxDeps = [
    "packaging"
  ];

  meta = {
    homepage = "https://www.pinecone.io/";
    maintainers = with lib.maintainers; [ codgician ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    description = "Assistant plugin for Pinecone SDK";
  };
}
