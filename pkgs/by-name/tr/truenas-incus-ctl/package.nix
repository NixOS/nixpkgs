{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "truenas-incus-ctl";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "truenas_incus_ctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F9bTh++yt6heYmkjYSOGXsIyS4s5yIIBS4F44JmIhwc=";
  };

  vendorHash = "sha256-4mm28T6nWTe3UvwGJ1S7s09ZSRZjm6TGcTD13vazUa4=";

  __structuredAttrs = true;

  meta = {
    description = "A CLI tool for managing Incus volumes on TrueNAS";
    homepage = "https://github.com/truenas/truenas_incus_ctl";
    changelog = "https://github.com/truenas/truenas_incus_ctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ysnt-yes ];
    mainProgram = "truenas_incus_ctl";
  };
})
