{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typstyle";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "typstyle-rs";
    repo = "typstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YAMC1IMs3TioTx3rnb5CdYgviR3gP89b2rfOuZVVg3M=";
  };

  cargoHash = "sha256-nmIDgt6KRYAEWmJxufj/TyYWuVGG6/tiYA8iTneKnVc=";

  # Disabling tests requiring network access
  checkFlags = [
    "--skip=e2e"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/typstyle-rs/typstyle/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/typstyle-rs/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [
      prince213
    ];
  };
})
