{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "yggdrasil";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L4eNrytAklblRrAQPf4zzgvrtHaZWmpTMcOLwkKMPCc=";
  };

  vendorHash = "sha256-z09K/ZDw9mM7lfqeyZzi0WRSedzgKED0Sywf1kJXlDk=";

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
