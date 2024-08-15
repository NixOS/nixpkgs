{
  buildPythonPackage,
  lib,
  fetchPypi,
  protobuf,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "s2clientprotocol";
  version = "5.0.13.92440.3";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-56VjdECnEIrBG1m1oA7F2rbDGH7mucBR2LZpIRnYSnU=";
  };

  buildInputs = [ protobuf ];

  pythonImportsCheck = [ "s2clientprotocol" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "StarCraft II - client protocol";
    homepage = "https://github.com/Blizzard/s2client-proto";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
