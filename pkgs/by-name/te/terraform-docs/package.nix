{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-docs";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = "terraform-docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yroGYLZX1MnCTVmDiTbWDNnwLcmTOT/jYECmFy/ZmRk=";
  };

  vendorHash = "sha256-k4xypyNk80EXH823oItjc45kkupjTSXHybnMrKEgFvs=";

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

  meta = {
    description = "Utility to generate documentation from Terraform modules in various output formats";
    mainProgram = "terraform-docs";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zimbatm
      anthonyroussel
    ];
  };
})
