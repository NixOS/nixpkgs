{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgsl-analyzer";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "wgsl-analyzer";
    repo = "wgsl-analyzer";
    tag = "v${version}";
    hash = "sha256-j9UUikbJojksR6Ak9mh32T4H5mZmtPfj1m7sItUiXY4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5eq/MvdtLl7wlSTwUkGRv1WurYMIBd6lmQYCDK96V1U=";

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
