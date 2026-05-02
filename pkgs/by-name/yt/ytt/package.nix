{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "ytt";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "ytt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xyWkKQps4ImsLUECNhysSkVuVpgj9uMgE4tpmzvcBJc=";
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
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} --version";
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
