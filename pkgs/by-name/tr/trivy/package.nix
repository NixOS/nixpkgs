{
  lib,
  stdenv,
  buildPackages,
<<<<<<< HEAD
  buildGoModule,
=======
  buildGo124Module,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  installShellFiles,
  testers,
  trivy,
}:
<<<<<<< HEAD
buildGoModule rec {
  pname = "trivy";
  version = "0.68.2";
=======

buildGo124Module rec {
  pname = "trivy";
  version = "0.66.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "trivy";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0s9N7BHLJOTnOfa9tQ70D5tfTDSEHsiLUYHpWZjuoEU=";
=======
    hash = "sha256-Kn28mUdCi/8FPrAa0UbfOaBlzkaGc9daYOR93t+n2uY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

<<<<<<< HEAD
  vendorHash = "sha256-0HbMMzkxDbDb/Q7s490JfjK63tPdWDuEbV2oQjvD1zI=";
=======
  vendorHash = "sha256-FabIeFGUX55zyMtGadHKGbJ7awlHgNzfO2IiiFKmIc4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/trivy" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/trivy/pkg/version/app.ver=${version}"
  ];

<<<<<<< HEAD
  env.GOEXPERIMENT = "jsonv2";

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ installShellFiles ];

  # Tests require network access
  doCheck = false;

<<<<<<< HEAD
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd trivy \
      --bash <($out/bin/trivy completion bash) \
      --fish <($out/bin/trivy completion fish) \
      --zsh <($out/bin/trivy completion zsh)
  '';
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
