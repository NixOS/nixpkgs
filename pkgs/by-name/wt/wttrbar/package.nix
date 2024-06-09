{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-lwlfarnu2PC5toAf6FAefnpxDlzzwphrP+zXRQ2DQeQ=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Security SystemConfiguration ]);

  cargoHash = "sha256-H3UpBRf97JsHudq6naZxMnpIzda0v7teDjgDdgluul0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
