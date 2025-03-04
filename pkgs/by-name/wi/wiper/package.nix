{
  lib,
  stdenv,
  darwin,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.2.1";
in
rustPlatform.buildRustPackage {
  pname = "wiper";
  inherit version;

  src = fetchFromGitHub {
    owner = "ikebastuz";
    repo = "wiper";
    tag = "v${version}";
    hash = "sha256-IheSAPk1l6wJ2v4RLPIPvY/5XMfh+vJLyQ/Lc7RrCJQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-p2bUiRLI0vfOAAi4Cb8B9E8kMVS6aX4ksbF+H9gMsDs=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Foundation ];

  meta = {
    description = "Disk analyser and cleanup tool";
    changelog = "https://github.com/ikebastuz/wiper/releases/tag/v${version}";
    homepage = "https://github.com/ikebastuz/wiper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "wiper";
  };
}
