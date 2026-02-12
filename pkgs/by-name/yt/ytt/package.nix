{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  ytt,
}:
buildGoModule (finalAttrs: {
  pname = "ytt";
  version = "0.52.2";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "ytt";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-x+Lar/GYr+uGQ8PdG1ZyCovPpl/dj1m5UcPbHaH3IWw=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X carvel.dev/ytt/pkg/version.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    inherit (finalAttrs) version;
  };

  meta = {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    mainProgram = "ytt";
    homepage = "https://get-ytt.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      brodes
      techknowlogick
      gabyx
    ];
  };
})
