{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  yaegi,
}:

buildGoModule (finalAttrs: {
  pname = "yaegi";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "yaegi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6nxOQgxNFa7kfJJGgfiwhxCWmwifT2H4rdBqoASfOog=";
  };

  vendorHash = "sha256-8IEFmv3YKuSo8Hqi6mz+5ki8uo4jjG0Geh0zfxvHEW0=";

  subPackages = [
    "cmd/yaegi"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = yaegi;
      command = "yaegi version";
    };
  };

  meta = {
    description = "Go interpreter";
    mainProgram = "yaegi";
    homepage = "https://github.com/traefik/yaegi";
    changelog = "https://github.com/traefik/yaegi/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
})
