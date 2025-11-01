{
  lib,
  buildGoModule,
  winboat,
}:
buildGoModule {
  inherit (winboat) version src;
  modRoot = "guest_server";
  pname = "winboat-guest-server";
  vendorHash = "sha256-JglpTv1hkqxmcbD8xmG80Sukul5hzGyyANfe+GeKzQ4=";

  env = {
    GOOS = "windows";
    GOARCH = "amd64";
    PACKAGE = "winboat-server";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${winboat.version}"
    "-X main.CommitHash=${winboat.src.rev}"
  ];

  meta = {
    mainProgram = "winboat-server.exe";
    description = "Guest server for winboat";
    homepage = "https://github.com/TibixDev/winboat";
    changelog = "https://github.com/TibixDev/winboat/releases/tag/v${winboat.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rexies
      ppom
    ];
    platforms = [ "x86_64-windows" ];
  };
}
