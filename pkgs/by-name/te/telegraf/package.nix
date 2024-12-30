{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  nixosTests,
  stdenv,
  testers,
  telegraf,
}:

buildGo123Module rec {
  pname = "telegraf";
  version = "1.33.0";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${version}";
    hash = "sha256-Psrhm854/9xywJlWKBGDbKMq6R3kVb2DGKI+c04PaLI=";
  };

  vendorHash = "sha256-QEg6vDghz6CWHsLs745kxt959+b3cj45Tjfb3moryzM=";
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
