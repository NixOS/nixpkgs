{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgsl-analyzer";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "wgsl-analyzer";
    repo = "wgsl-analyzer";
    tag = "v${version}";
    hash = "sha256-UizD6cTRs6M5GaOX3wvacMr5JWwyHrQS6L19fRnw6Xo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W1WQ00SFpYOm4J1C65Jg1Yb3pujdcDQFdrpIgqKRLk4=";

  checkFlags = [
    # Imports failures
    "--skip=tests::parse_import"
    "--skip=tests::parse_import_colon"
    "--skip=tests::parse_string_import"
    "--skip=tests::struct_recover_3"
  ];

  meta = {
    description = "Language server implementation for the WGSL shading language";
    homepage = "https://github.com/wgsl-analyzer/wgsl-analyzer";
    changelog = "https://github.com/wgsl-analyzer/wgsl-analyzer/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "wgsl-analyzer";
  };
}
