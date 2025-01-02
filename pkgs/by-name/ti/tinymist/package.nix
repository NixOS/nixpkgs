{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  versionCheckHook,
  nix-update-script,
  vscode-extensions,
}:

rustPlatform.buildRustPackage rec {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.12.14";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    tag = "v${version}";
    hash = "sha256-F6nJH3JU8NxyxFevYMaQnPDTIcjcqM779CP4M1zp1rU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+Ce9qIETGFZXG4RX5GP8tpmH4fkpbPkDS1FX64NQ6/4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  checkFlags = [
    "--skip=e2e"

    # Require internet access
    "--skip=docs::package::tests::cetz"
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
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "-V" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      vscode-extension = vscode-extensions.myriad-dreamin.tinymist;
    };
  };

  meta = {
    changelog = "https://github.com/Myriad-Dreamin/tinymist/blob/v${version}/CHANGELOG.md";
    description = "Tinymist is an integrated language service for Typst";
    homepage = "https://github.com/Myriad-Dreamin/tinymist";
    license = lib.licenses.asl20;
    mainProgram = "tinymist";
    maintainers = with lib.maintainers; [
      GaetanLepage
      lampros
    ];
  };
}
