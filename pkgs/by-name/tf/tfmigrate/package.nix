{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tfmigrate";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfmigrate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+5nw+EgFTor8XL4cibxkpJL4fdEQ6UuEj5wyOjpaANA=";
  };

  vendorHash = "sha256-mm34U4nLow4lCz/AgfqYZJRb71GpQjR14+tm0hfmdDc=";

  checkFlags = [
    "-skip TestExecutorDir" # assumes /usr/bin to be present
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Terraform / OpenTofu state migration tool for GitOps ";
    homepage = "https://github.com/minamijoyo/tfmigrate";
    changelog = "https://github.com/minamijoyo/tfmigrate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "tfmigrate";
  };
})
