{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
}:
# Swytch requires Go >= 1.27.0; use the latest Go toolchain
# while nixpkgs' default Go builder is on an older version.
buildGoLatestModule (finalAttrs: {
  pname = "swytch";
  version = "1.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "swytchdb";
    repo = "swytch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wpwfy5I90ZSjuwgoApnh2GliWdqqSB9/FSEyX8RGsf4=";
  };

  vendorHash = "sha256-rjX0bB4WsFS3T6ETdCH9P08jXSVshj5dmbfmkmVM4mA=";

  subPackages = [ "." ];
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X=main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Swytch is a leaderless, Redis-compatible cache with database-level consistency";
    homepage = "https://github.com/swytchdb/swytch";
    changelog = "https://github.com/swytchdb/swytch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "swytch";

    maintainers = with lib.maintainers; [
      pk82869
      withinboredom
    ];
  };
})
