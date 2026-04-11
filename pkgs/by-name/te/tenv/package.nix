{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  tenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "tenv";
  version = "4.9.3";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gaz2zGYYYCo3iDAiA3gVg2BYgeZrZMHcALbBHE0pRvM=";
  };

  vendorHash = "sha256-DtcOAdkd9JrfGKwkHixx2Qgjij7u7MVr96oNpPqTz14=";

  excludedPackages = [ "tools" ];

  # Tests disabled for requiring network access to release.hashicorp.com
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tenv \
      --zsh <($out/bin/tenv completion zsh) \
      --bash <($out/bin/tenv completion bash) \
      --fish <($out/bin/tenv completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    command = "HOME=$TMPDIR tenv --version";
    package = tenv;
    version = "v${finalAttrs.version}";
  };

  meta = {
    changelog = "https://github.com/tofuutils/tenv/releases/tag/v${finalAttrs.version}";
    description = "OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go";
    homepage = "https://tofuutils.github.io/tenv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rmgpinto
      nmishin
      kvendingoldo
    ];
  };
})
