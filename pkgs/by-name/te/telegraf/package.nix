{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
  testers,
  telegraf,
}:

buildGoModule (finalAttrs: {
  pname = "telegraf";
  version = "1.38.2";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EfT3uxUTRvAlZcIsm7zDn+6znE7UG+N0yBoGM5Fl8eo=";
  };

  vendorHash = "sha256-Ir9/JjnwfrxlF7oCTpsn/e+8UxdZJgCZM2SW3y2h1Rg=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${finalAttrs.src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = telegraf;
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit (nixosTests) telegraf;
  };

  meta = {
    description = "Plugin-driven server agent for collecting & reporting metrics";
    mainProgram = "telegraf";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mic92
      roblabla
      timstott
      zowoq
    ];
  };
})
