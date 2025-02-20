{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  buildPackages,
  versionCheckHook,
  nix-update-script,
  vscode-extensions,
}:

rustPlatform.buildRustPackage rec {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.12.20";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    tag = "v${version}";
    hash = "sha256-MFAbG0K71LbMAZKZ0Bo9ms6UTPNetORmHlBwYAusUtE=";
  };

  patches = [
    # Fixes:
    # cargo metadata failure: error: Package `tinymist-std v0.12.20 (/build/source/crates/tinymist-std)` does not have feature `wasm-bindgen`.
    # It has an optional dependency with that name, but that dependency uses the "dep:" syntax in the features table, so it does not have an implicit feature with that name.
    # https://github.com/Myriad-Dreamin/tinymist/pull/1363
    (fetchpatch {
      name = "fix-cargo-features";
      url = "https://github.com/Myriad-Dreamin/tinymist/pull/1363/commits/96e0a15fa20f09734f2b8152977a1137f5469761.patch";
      hash = "sha256-W3HzV0GGhGuX/V4rox32LSw6YJ2BLTAG16bF2pZ+xYs=";
    })
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-mk6JQEDgY8ERKq7dy+HlU7go4ImeJpGONOBSjjHdD4g=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

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

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd tinymist \
        --bash <(${emulator} $out/bin/tinymist completion bash) \
        --fish <(${emulator} $out/bin/tinymist completion fish) \
        --zsh <(${emulator} $out/bin/tinymist completion zsh)
    '';

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
