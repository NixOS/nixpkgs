{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tslib";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "libts";
    repo = "tslib";
    tag = finalAttrs.version;
    hash = "sha256-2YJDADh/WCksAEIjngAdji98YGmwjpvxSBZkxAwFc7k=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Touchscreen access library";
    homepage = "http://www.tslib.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = with lib.teams; [ ngi ];
  };
})
