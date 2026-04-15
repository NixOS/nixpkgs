{
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "pinecone-plugin-assistant";
  version = "3.0.2";

  pyproject = true;

  src = fetchPypi {
    pname = "pinecone_plugin_assistant";
    inherit version;
    hash = "sha256-BBY68oKteJW1gauJ+FDtE55N3OpyAQyt+kxXN1nVyJY=";
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
