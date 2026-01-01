{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGo125Module (finalAttrs: {
  pname = "terragrunt";
<<<<<<< HEAD
  version = "0.96.0";
=======
  version = "0.93.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-KIfhgzPQwN3AieWexjiWOMrVNTyK0/kuubP2LQk10QE=";
  };

  nativeBuildInputs = [
    mockgen
  ];

  proxyVendor = true;

=======
    hash = "sha256-aq3Q+PsKtkFXvBxZ1dpXsXWcQFEBTR1T/q/svWsEljg=";
  };

  nativeBuildInputs = [
    versionCheckHook
    mockgen
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  preBuild = ''
    make generate-mocks
  '';

<<<<<<< HEAD
  vendorHash = "sha256-cjbVE8b8CKSl7cRkMuHMKcRb/Yj26oLKU3rAdRCBbk0=";
=======
  vendorHash = "sha256-SLRWtOBPa2jVWTHVYfjlEEfK+I/ZKA3ls/LLV5/oLfQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false;

  ldflags = [
    "-s"
<<<<<<< HEAD
=======
    "-w"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "-X github.com/gruntwork-io/go-commons/version.Version=v${finalAttrs.version}"
    "-extldflags '-static'"
  ];

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
=======
  doInstallCheck = true;

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${finalAttrs.version}";
    description = "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      jk
      qjoly
      kashw2
    ];
  };
})
