{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "discord-protos";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5U6BfMr7ttAtwjsS0V1MKYZaknI110zeukoKipByZc=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  pythonImportsCheck = [ "discord_protos" ];

  meta = {
    description = "Discord's protocol buffer definitions for Python";
    homepage = "https://github.com/dolfies/discord-protos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ epwv ];
  };
}
