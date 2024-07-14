{
  buildPythonPackage,
  lib,
  fetchPypi,
  protobuf,
}:

buildPythonPackage rec {
  pname = "s2clientprotocol";
  version = "3.19.1.58600.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jhz6PirxGpxTaPk5j1LF+kxe8QEHOFsYeer+Il3jWAo=";
  };

  patches = [ ./pure-version.patch ];

  buildInputs = [ protobuf ];

  meta = {
    description = "StarCraft II - client protocol";
    homepage = "https://github.com/Blizzard/s2client-proto";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
