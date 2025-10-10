{
  stdenv,
  lib,
  # Build fails with Go 1.25, with the following error:
  # 'vendor/golang.org/x/tools/internal/tokeninternal/tokeninternal.go:64:9: invalid array length -delta * delta (constant -256 of type int64)'
  # Wait for upstream to update their vendored dependencies before unpinning.
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGo124Module (finalAttrs: {
  pname = "terraform-docs";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = "terraform-docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DiKoYAe7vcNy35ormKHYZcZrGK/MEb6VmcHWPgrbmUg=";
  };

  vendorHash = "sha256-ynyYpX41LJxGhf5kF2AULj+VKROjsvTjVPBnqG+JGSg=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  excludedPackages = [ "scripts" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/terraform-docs completion bash >terraform-docs.bash
    $out/bin/terraform-docs completion fish >terraform-docs.fish
    $out/bin/terraform-docs completion zsh >terraform-docs.zsh
    installShellCompletion terraform-docs.{bash,fish,zsh}
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    description = "Utility to generate documentation from Terraform modules in various output formats";
    mainProgram = "terraform-docs";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [
      zimbatm
      anthonyroussel
    ];
  };
})
