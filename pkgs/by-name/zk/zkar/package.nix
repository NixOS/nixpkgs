{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zkar";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "phith0n";
    repo = "zkar";
    tag = "v${version}";
    hash = "sha256-xnj3GOZoLPE/kyGgi5i2o61P7Snt0L0JRGHLGNQDLRI=";
  };

  vendorHash = "sha256-Eyi22d6RkIsg6S5pHXOqn6kULQ/mLeoaxSxxJJkMgIQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Java serialization protocol analysis tool";
    homepage = "https://github.com/phith0n/zkar";
    changelog = "https://github.com/phith0n/zkar/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zkar";
  };
}
