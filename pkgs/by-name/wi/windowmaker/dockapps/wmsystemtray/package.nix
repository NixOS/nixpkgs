{
  lib,
  fetchurl,
  libX11,
  libXext,
  libXfixes,
  libXmu,
  libXpm,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmsystemtray";
  version = "1.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/wmsystemtray/wmsystemtray/wmsystemtray-${finalAttrs.version}.tar.gz";
    hash = "sha256-jt70NpHp//BxAA4pFmx8GtQgwJVukGgVEGHogcisl+k=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXext
    libXfixes
    libXmu
    libXpm
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "wmsystemtray -V";
      };
    };
  };

  meta = {
    homepage = "http://wmsystemtray.sourceforge.net";
    description = "System tray for Windowmaker";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
