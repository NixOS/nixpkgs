{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
  versionCheckHook,
  nix-update-script,
  vscode-extensions,
}:

rustPlatform.buildRustPackage rec {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.11.32";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    rev = "refs/tags/v${version}";
    hash = "sha256-xXrE4LOzcR4TCoBD7jbS1Ba7kBLBPiF3GI0wjq5GXWA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.11.1" = "sha256-dQf4qYaOni/jwIjRVXXCZLTn6ox3v6EyhCbaONqNtcw=";
      "typst-syntax-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
      "typstfmt_lib-0.2.7" = "sha256-LBYsTCjZ+U+lgd7Z3H1sBcWwseoHsuepPd66bWgfvhI=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.CoreFoundation
      darwin.apple_sdk_11_0.frameworks.CoreServices
      darwin.apple_sdk_11_0.frameworks.Security
      darwin.apple_sdk_11_0.frameworks.SystemConfiguration
    ];

  checkFlags = [
    "--skip=e2e"

    # Fails because of missing `creation_timestamp` field
    # https://github.com/NixOS/nixpkgs/pull/328756#issuecomment-2241322796
    "--skip=test_config_update"

    # Require internet access
    "--skip=docs::tests::cetz"
    "--skip=docs::tests::tidy"
    "--skip=docs::tests::touying"
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
    changelog = "https://github.com/Myriad-Dreamin/tinymist/blob/${src.rev}/CHANGELOG.md";
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
