{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zkar";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "phith0n";
    repo = "zkar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7vpcfmUu/dmQILpO/WRtM92UrUMrZHBNWIM9CoH81as=";
  };

  vendorHash = "sha256-Eyi22d6RkIsg6S5pHXOqn6kULQ/mLeoaxSxxJJkMgIQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Java serialization protocol analysis tool";
    homepage = "https://github.com/phith0n/zkar";
    changelog = "https://github.com/phith0n/zkar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zkar";
  };
})
