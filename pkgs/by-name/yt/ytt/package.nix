{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  ytt,
}:
buildGoModule rec {
  pname = "ytt";
<<<<<<< HEAD
  version = "0.52.2";
=======
  version = "0.52.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "ytt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-x+Lar/GYr+uGQ8PdG1ZyCovPpl/dj1m5UcPbHaH3IWw=";
=======
    sha256 = "sha256-fSrvsRZpXXvR6SpEigEMiP0lU5y+ddidHwtz+rmgSb4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X carvel.dev/ytt/pkg/version.Version=${version}"
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
    inherit version;
  };

<<<<<<< HEAD
  meta = {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    mainProgram = "ytt";
    homepage = "https://get-ytt.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    mainProgram = "ytt";
    homepage = "https://get-ytt.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      brodes
      techknowlogick
      gabyx
    ];
  };
}
