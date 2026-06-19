{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "trivy";
  version = "0.71.2";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "trivy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GC9WiGp2Cn0SmErRxAdjpDJvoF0giKrj+NJAC5CaXV8=";
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

  vendorHash = "sha256-Xr24mc1nDevpeACKciw1g1bTfLtCEwxfOuwPNxVhGxo=";

  subPackages = [ "cmd/trivy" ];

  ldflags = [
    "-s"
    "-X=github.com/aquasecurity/trivy/pkg/version/app.ver=${finalAttrs.version}"
  ];

  env.GOEXPERIMENT = "jsonv2";

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Tests require network access
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd trivy \
      --bash <($out/bin/trivy completion bash) \
      --fish <($out/bin/trivy completion fish) \
      --zsh <($out/bin/trivy completion zsh)
  '';

  doInstallCheck = true;

  meta = {
    description = "Simple and comprehensive vulnerability scanner for containers, suitable for CI";
    homepage = "https://github.com/aquasecurity/trivy";
    changelog = "https://github.com/aquasecurity/trivy/releases/tag/${finalAttrs.src.tag}";
    longDescription = ''
      Trivy is a simple and comprehensive vulnerability scanner for containers
      and other artifacts. A software vulnerability is a glitch, flaw, or
      weakness present in the software or in an Operating System. Trivy detects
      vulnerabilities of OS packages (Alpine, RHEL, CentOS, etc.) and
      application dependencies (Bundler, Composer, npm, yarn, etc.).
    '';
    mainProgram = "trivy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      jk
    ];
  };
})
