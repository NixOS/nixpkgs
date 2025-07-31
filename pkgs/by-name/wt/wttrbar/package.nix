{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-gJJnmJ1dpKVCRZtzL1R86s607hOCHTpsFDPsQKOnvvA=";
  };

  cargoHash = "sha256-WMRDUAefYjXY03EqTZf3VNJuypxu07RTyDmdlB6a0kk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
