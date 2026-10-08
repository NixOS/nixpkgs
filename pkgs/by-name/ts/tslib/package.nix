{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tslib";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "libts";
    repo = "tslib";
    tag = finalAttrs.version;
    hash = "sha256-WrzOTZlceYnFXi5AI5vb+ZDSRoqUDk/yyCdBUWKn0sM=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Touchscreen access library";
    homepage = "http://www.tslib.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux; # requires linux headers <linux/input.h>
    maintainers = with lib.maintainers; [ shogo ];
    teams = with lib.teams; [ ngi ];
  };
})
