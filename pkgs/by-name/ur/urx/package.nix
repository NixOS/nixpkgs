{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "urx";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "urx";
    tag = finalAttrs.version;
    hash = "sha256-mGFTCKsubT+gIUxdgRAhE69WtgMghkKII/73Auffrt4=";
  };

  cargoHash = "sha256-PRP+iGH3fzfPOUQZAaIab7BSAUGZyxF1MX7tbfAIDks=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;

  checkFlags = [
    # Tests require network access
    "--skip=providers"
    "--skip=network::client::tests"
    "--skip=link_extractor::tests::test_client_is_built_once_and_reused"
    "--skip=link_extractor::tests::test_reused_client_extracts_from_multiple_urls"
    "--skip=status_checker::tests::test_client_is_built_once_and_reused"
    "--skip=status_checker::tests::test_clones_share_one_client"
    "--skip=status_checker::tests::test_reused_client_checks_multiple_urls"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Extracts URLs from OSINT Archives for Security Insights";
    homepage = "https://github.com/hahwul/urx";
    changelog = "https://github.com/hahwul/urx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "urx";
  };
})
