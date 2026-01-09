{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tfmigrate";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfmigrate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-633b7VZ0/JNWuBh0C9CtbG5XdgTD2zLuotBbgv0a2e8=";
  };

  vendorHash = "sha256-TqZi5NZ+4eSzq98/ZM4Gab7Sud7bz1DNHrp5nGaGHDE=";

  checkFlags = [
    "-skip TestExecutorDir" # assumes /usr/bin to be present
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terraform / OpenTofu state migration tool for GitOps ";
    homepage = "https://github.com/minamijoyo/tfmigrate";
    changelog = "https://github.com/minamijoyo/tfmigrate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "tfmigrate";
  };
})
