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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-rUiLB0M/dzNxzBPAqlGy5m/gOTGYw4GRzb+ud0l/1+8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk_11_0.frameworks;
    [
      Security
      SystemConfiguration
    ]
  );

  cargoHash = "sha256-v415OJ6dmWSLUDeFUtd27mBaQlB3x1vC37sjpMhKyYY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
