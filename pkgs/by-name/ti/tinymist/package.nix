{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  buildPackages,
  versionCheckHook,
  nix-update-script,
  vscode-extensions,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SfkyyszTmleWHa19jMgHjiOUvBOniVybDr9GBmtMVDw=";
  };

  cargoHash = "sha256-ztJb2Br0Ph2qSeo9MGm9OdU66YPkep+9lBCrL2TimB4=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  checkFlags = [
    "--skip=e2e"

    # Require internet access
    "--skip=docs::package::tests::cetz"
    "--skip=docs::package::tests::fletcher"
    "--skip=docs::package::tests::tidy"
    "--skip=docs::package::tests::touying"

    # Tests are flaky for unclear reasons since the 0.12.3 release
    # Reported upstream: https://github.com/Myriad-Dreamin/tinymist/issues/868
    "--skip=analysis::expr_tests::scope"
    "--skip=analysis::post_type_check_tests::test"
    "--skip=analysis::type_check_tests::test"
    "--skip=completion::tests::test_pkgs"
    "--skip=folding_range::tests::test"
    "--skip=goto_definition::tests::test"
    "--skip=hover::tests::test"
    "--skip=inlay_hint::tests::smart"
    "--skip=prepare_rename::tests::prepare"
    "--skip=references::tests::test"
    "--skip=rename::tests::test"
    "--skip=semantic_tokens_full::tests::test"

    # Return "No compatible device found" when testing preview
    "--skip=doc::tests::diff_v1_preview_frame_paints_generated_page"
    "--skip=doc::tests::full_current_preview_frame_paints_generated_page_after_reset"
    "--skip=doc::tests::page_canvas_exposes_synthetic_accesskit_link_nodes"
    "--skip=doc::tests::page_canvas_exposes_synthetic_accesskit_text_runs"
    "--skip=doc::tests::page_canvas_paints_selection_overlay_above_scene"
    "--skip=doc::tests::page_canvas_paints_supplied_white_background"
    "--skip=doc::tests::page_canvas_selects_and_copies_text"
    "--skip=doc::tests::page_canvas_uses_pointer_cursor_over_links"
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd tinymist \
        --bash <(${emulator} $out/bin/tinymist completion bash) \
        --fish <(${emulator} $out/bin/tinymist completion fish) \
        --zsh <(${emulator} $out/bin/tinymist completion zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      vscode-extension = vscode-extensions.myriad-dreamin.tinymist;
    };
  };

  meta = {
    description = "Integrated language service for Typst";
    homepage = "https://github.com/Myriad-Dreamin/tinymist";
    changelog = "https://github.com/Myriad-Dreamin/tinymist/blob/v${finalAttrs.version}/editors/vscode/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "tinymist";
    maintainers = with lib.maintainers; [
      GaetanLepage
      lampros
    ];
  };
})
