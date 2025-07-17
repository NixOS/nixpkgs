{
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
  pinecone-plugin-interface,
}:

buildPythonPackage rec {
  pname = "pinecone-plugin-inference";
  version = "3.1.0";

  pyproject = true;

  src = fetchPypi {
    pname = "pinecone_plugin_inference";
    inherit version;
    hash = "sha256-7/gmF44f5EhXe+L/PY27Byvvu9wtiI4hRiRSOhw3zY0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pinecone-plugin-interface
  ];

  meta = {
    homepage = "https://www.pinecone.io/";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    description = "Embeddings plugin for Pinecone SDK";
  };
}
