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
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-FJexqBzsLeaF7iWWwcenRINpMRtkpThxLWlMEectjfQ=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk_11_0.frameworks;
    [
      Security
      SystemConfiguration
    ]
  );

  cargoHash = "sha256-4pcMcCxidNY4EIvYWGa/cfovRGHMEIcVfJWiMG/8aog=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
