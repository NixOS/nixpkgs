{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wgsl-analyzer";
  version = "2025-11-04";

  src = fetchFromGitHub {
    owner = "wgsl-analyzer";
    repo = "wgsl-analyzer";
    tag = finalAttrs.version;
    hash = "sha256-DvCZA4IWv+uqGlihAInJMh2DzgQNkEsGptCHV4pI7Fo=";
  };

  cargoHash = "sha256-cbbuZ9kkYfjvY1Aq27in1poODowtVoP+m3TLHn+zT3E=";

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
