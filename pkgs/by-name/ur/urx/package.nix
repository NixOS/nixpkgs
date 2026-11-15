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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "urx";
    tag = finalAttrs.version;
    hash = "sha256-BsOcYQ2dOBXkl2eqEWyaCEsaqg/W5OGILIFb8F7DM94=";
  };

  cargoHash = "sha256-4bw6zVAe+W4jceFO1SmGPQQ5pU52MS+2oyE7cF+l5yc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;

  checkFlags = [
    # Tests require network access
    "--skip=providers"
    "--skip=network::client::tests"
    "--skip=notify::tests"
    "--skip=tester_manager::tests::custom_headers_reach_the_target_but_never_the_archive"
    "--skip=testers::archive_body::tests"
    "--skip=testers::js_endpoint_extractor::tests"
    "--skip=testers::link_extractor::tests"
    "--skip=testers::spec_expander::tests"
    "--skip=testers::status_checker::tests"
    "--skip=output::writer::tests::test_render_produces_the_same_bytes_for_every_destination"
    "--skip=link_extractor::tests::test_client_is_built_once_and_reused"
    "--skip=link_extractor::tests::test_reused_client_extracts_from_multiple_urls"
    "--skip=status_checker::tests::test_client_is_built_once_and_reused"
    "--skip=status_checker::tests::test_clones_share_one_client"
    "--skip=status_checker::tests::test_reused_client_checks_multiple_urls"
  ];

  doInstallCheck = true;

  meta = {
    description = "Extracts URLs from OSINT Archives for Security Insights";
    homepage = "https://github.com/hahwul/urx";
    changelog = "https://github.com/hahwul/urx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "urx";
  };
})
