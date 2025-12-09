{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  trivy,
}:
buildGoModule rec {
  pname = "trivy";
  version = "0.68.2";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "trivy";
    tag = "v${version}";
    hash = "sha256-0s9N7BHLJOTnOfa9tQ70D5tfTDSEHsiLUYHpWZjuoEU=";
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

  vendorHash = "sha256-0HbMMzkxDbDb/Q7s490JfjK63tPdWDuEbV2oQjvD1zI=";

  subPackages = [ "cmd/trivy" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/trivy/pkg/version/app.ver=${version}"
  ];

  env.GOEXPERIMENT = "jsonv2";

  nativeBuildInputs = [ installShellFiles ];

  # Tests require network access
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd trivy \
      --bash <($out/bin/trivy completion bash) \
      --fish <($out/bin/trivy completion fish) \
      --zsh <($out/bin/trivy completion zsh)
  '';

  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = trivy;
    command = "trivy --version";
    version = "Version: ${version}";
  };

  meta = {
    description = "Simple and comprehensive vulnerability scanner for containers, suitable for CI";
    homepage = "https://github.com/aquasecurity/trivy";
    changelog = "https://github.com/aquasecurity/trivy/releases/tag/v${version}";
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
}
