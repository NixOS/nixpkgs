{
  lib,
  python3,
  fetchPypi,
  rustPlatform,
  nix-update-script,
}:
let
  pname = "fastcrc";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tip1NZ2XpZRpu8vXdRPoAdPzZmqRaWKVePiAEsDy1/4=";
  };
in
python3.pkgs.buildPythonPackage {
  inherit pname version src;
  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.7";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-HSYntwCIHtfAaIdEqw7kofO3lpeYcCiGlafOgI5K7mk=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A hyper-fast Python module for computing CRC(8, 16, 32, 64) checksum";
    homepage = "https://fastcrc.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
