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
  # As of March 2026, trivy has made compromised releases twice.
  # At a minimum, before updating, check the diff of this package, and of all
  # dependencies/GitHub Actions changes, carefully.
  # Also read about how the previous compromises occurred, and ensure
  # that the signs present then are not present now.
  # Finally, weigh the risk of a compromised release against the expected
  # benefit of the update, and consider the possibility of not updating.
  version = "0.69.3"; # Did you read the comment?

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "trivy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lzFcLyrORA+1LxS4nzJVvilg29GTNiGRmnjJ47ev/yU=";
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

  vendorHash = "sha256-aqSB2pakYH713GSbIAHwAL9Gio17MzZtwqfh9sbzDBs=";

  subPackages = [ "cmd/trivy" ];

  ldflags = [
    "-s"
    "-w"
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
