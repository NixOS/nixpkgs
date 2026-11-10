{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-toys";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Seebass22";
    repo = "terminal-toys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XFsgFjo6Bga32gR2FVXODJFw3zMdrqcq8AIijiQu+tE=";
  };

  cargoHash = "sha256-fIYGTduA1hE17bKhiS8IztFIuktmQSEAQ/o4wQKcuZY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screensavers for your terminal";
    homepage = "https://github.com/Seebass22/terminal-toys";
    changelog = "https://github.com/Seebass22/terminal-toys/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "terminal-toys";
  };
})
