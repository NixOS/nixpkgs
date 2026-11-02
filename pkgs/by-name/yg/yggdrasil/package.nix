{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "yggdrasil";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z8niRksjOC6ZPx6Ot9QG9R3ZLWIJBTIjwGEa2EvBlg8=";
  };

  vendorHash = "sha256-pZjyeDNZFpXhFUs50JzBmo46jQv66YghT6OzuOh6eDg=";

  # These tests require root, but look up the build user before skipping.
  # Sandboxed Darwin build UIDs may have no account database entry.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip=^(TestCurrentUserid|TestCommonUsername)$"
  ];

  subPackages = [
    "cmd/genkeys"
    "cmd/yggdrasil"
    "cmd/yggdrasilctl"
  ];

  ldflags = [
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${finalAttrs.version}"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=yggdrasil"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/config.defaultAdminListen=unix:///var/run/yggdrasil/yggdrasil.sock"
    "-s"
    "-w"
  ];

  passthru.tests.basic = nixosTests.yggdrasil;

  meta = {
    description = "Experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = lib.licenses.lgpl3;
    mainProgram = "yggdrasil";
    maintainers = with lib.maintainers; [
      gazally
      lassulus
      peigongdsd
    ];
  };
})
