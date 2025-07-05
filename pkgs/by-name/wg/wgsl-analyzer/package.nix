{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wgsl-analyzer";
  version = "2025-06-28";

  src = fetchFromGitHub {
    owner = "wgsl-analyzer";
    repo = "wgsl-analyzer";
    tag = finalAttrs.version;
    hash = "sha256-X4BUZWrCmyixM6D7785jsQ4XYhXemQ7ycl0FUijevkg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PEhvnIVjNi0O2ZqzSW/CRaK4r5pzd7sMUDhB2eGpqk8=";

  checkFlags = [
    # Imports failures
    "--skip=tests::parse_import"
    "--skip=tests::parse_import_colon"
    "--skip=tests::parse_string_import"
    "--skip=tests::struct_recover_3"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server implementation for the WGSL shading language";
    homepage = "https://github.com/wgsl-analyzer/wgsl-analyzer";
    changelog = "https://github.com/wgsl-analyzer/wgsl-analyzer/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "wgsl-analyzer";
  };
})
