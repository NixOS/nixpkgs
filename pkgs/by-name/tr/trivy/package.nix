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
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "trivy";
    tag = "v${version}";
    hash = "sha256-DIBpuSW8igkpZxhve77fzJ1u3sp3iWHmi7746F0cKEQ=";
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

  vendorHash = "sha256-kRKGX3hRbjLb/thhFcX4/y1ty0EGME63VGOsPaUcZKc=";

  subPackages = [ "cmd/trivy" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/trivy/pkg/version/app.ver=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Tests require network access
  doCheck = false;

  postInstall =
    let
      trivy =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.trivy;
    in
    ''
      installShellCompletion --cmd trivy \
        --bash <(${trivy}/bin/trivy completion bash) \
        --fish <(${trivy}/bin/trivy completion fish) \
        --zsh <(${trivy}/bin/trivy completion zsh)
    '';

  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = trivy;
    command = "trivy --version";
    version = "Version: ${version}";
  };

  meta = with lib; {
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
    license = licenses.asl20;
    maintainers = with maintainers; [
      fab
      jk
    ];
  };
}
