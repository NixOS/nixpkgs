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

  meta = with lib; {
    homepage = "https://www.pinecone.io/";
    maintainers = with maintainers; [ bot-wxt1221 ];
    license = licenses.asl20;
    platforms = platforms.unix;
    description = "Plugin interface for the Pinecone python client";
  };
}
