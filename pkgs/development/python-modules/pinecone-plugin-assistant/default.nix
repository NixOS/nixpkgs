{
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "pinecone-plugin-assistant";
  version = "3.0.1";

  pyproject = true;

  src = fetchPypi {
    pname = "pinecone_plugin_assistant";
    inherit version;
    hash = "sha256-awDpTvG/Ve1gHSMW7m9x+W+TvyFVJ3qCZjg5XhCQ3eM=";
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
