{
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pinecone-plugin-interface";
  version = "0.0.7";

  pyproject = true;

  src = fetchPypi {
    pname = "pinecone_plugin_interface";
    inherit version;
    hash = "sha256-uOZnXkGEczOqE5I8xE2qP4VnbXFXMkaC3BZAWIqYKEY=";
  };

  build-system = [
    poetry-core
  ];

  meta = {
    homepage = "https://www.pinecone.io/";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    description = "Plugin interface for the Pinecone python client";
  };
}
