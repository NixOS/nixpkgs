{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typstyle";
  version = "0.15.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "typstyle-rs";
    repo = "typstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YkE0fUxZclLM0Nd2hA2mwWfQo/cBvV9IMH7BF6BmEz8=";
  };

  cargoHash = "sha256-UOy+BMJ9h7+rK5Lsaoh3wItXdR4TJZ6baNDXX98vAQ4=";

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
