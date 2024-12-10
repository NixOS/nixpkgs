{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-EEc64pTAdVZZJtzHzACxZktUJMz10yuqdYG+N1CAD8k=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk_11_0.frameworks;
    [
      Security
      SystemConfiguration
    ]
  );

  cargoHash = "sha256-UXC7b0FDyKSRpYGJOLcG0mqZgKTLJA+eTqKMp1Zo1so=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
