{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  ytt,
}:
buildGoModule rec {
  pname = "ytt";
  version = "0.52.1";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "ytt";
    rev = "v${version}";
    sha256 = "sha256-fSrvsRZpXXvR6SpEigEMiP0lU5y+ddidHwtz+rmgSb4=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X carvel.dev/ytt/pkg/version.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd ytt \
      --bash <($out/bin/ytt completion bash) \
      --fish <($out/bin/ytt completion fish) \
      --zsh <($out/bin/ytt completion zsh)
  '';

  # Once `__structuredArgs` is introduced, integrate checks and
  # set some regexes `checkFlags = [ "-skip=TestDataValues.*" ]`
  # etc. So far we dont test because passing '*' chars through the Go builder
  # is flawed.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ytt;
    command = "ytt --version";
    inherit version;
  };

  meta = with lib; {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    mainProgram = "ytt";
    homepage = "https://get-ytt.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      brodes
      techknowlogick
      gabyx
    ];
  };
}
