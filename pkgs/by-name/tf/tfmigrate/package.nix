{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tfmigrate";
<<<<<<< HEAD
  version = "0.4.4";
=======
  version = "0.4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfmigrate";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-633b7VZ0/JNWuBh0C9CtbG5XdgTD2zLuotBbgv0a2e8=";
=======
    hash = "sha256-tuLbcxJj8TsG3I/o3cHO2DtQm9ql3wlhYBtYiMbRW7o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
