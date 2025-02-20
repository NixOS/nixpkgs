{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
  testers,
  telegraf,
}:

buildGoModule rec {
  pname = "telegraf";
  version = "1.33.2";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    hash = "sha256-DOsjECXi2OEhSFd+eDXGN0kIZgZdpng6hkNMh6cOQ88=";
  };

  vendorHash = "sha256-6valHYL2A4+rw1oMw4APT05O9gmj3+zUJQf226GDBaw=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${version}"
  ];

  passthru.tests =
    {
      version = testers.testVersion {
        package = telegraf;
      };
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) telegraf;
    };

  meta = with lib; {
    description = "Plugin-driven server agent for collecting & reporting metrics";
    mainProgram = "telegraf";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      mic92
      roblabla
      timstott
      zowoq
    ];
  };
}
