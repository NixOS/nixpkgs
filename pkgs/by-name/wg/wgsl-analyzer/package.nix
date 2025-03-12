{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgsl-analyzer";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "wgsl-analyzer";
    repo = "wgsl-analyzer";
    tag = "v${version}";
    hash = "sha256-su9ZhDeZSGcDT3Wnoh/Z9i+rCaApD9bJRAWTgvWdFHA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yGA6qugaoN39mryICi6cYNnnVdh+QCc1bRQdAgqcxcQ=";

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
