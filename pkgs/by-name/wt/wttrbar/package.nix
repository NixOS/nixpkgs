{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-2DaFbwzxpV5vNOey9me/Tj5t9idszTZHoj1cl4RkoeE=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Security SystemConfiguration ]);

  cargoHash = "sha256-rbsRW+c3rzHCMwFQAS22tIfbwudaqpVmRsGXFKOEWkQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
