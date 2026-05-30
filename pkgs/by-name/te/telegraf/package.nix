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
  version = "1.38.4";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sd0kZz2R+DusoBH6J2B3DRJmwaWYNWiIJ2QsOq8Y+3g=";
  };

  vendorHash = "sha256-ZBAeuDF2SgqZx2XeoE3yN8Q6fVj8/zjtU7GogF/Z1Kg=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${finalAttrs.src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${finalAttrs.version}"
  ]
  # Binary is too large for the default GOT PLT displacments on 32-bit ARM;
  # need to use larger encoding otherwise linking fails with:
  # BFD (GNU Binutils) 2.46 assertion fail /build/binutils-with-gold-2.46/bfd/elf32-arm.c:9783
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    "-extldflags"
    "-Wl,--long-plt"
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
