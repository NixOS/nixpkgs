{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libX11,
  libXext,
  libXpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmclock";
  version = "1.0.16";

  src = fetchurl {
    url = "https://www.dockapps.net/download/wmclock-${finalAttrs.version}.tar.gz";
    hash = "sha256-P4u13zFg1ZGdGc8m1FRJ5uEmDSovSF5h815kpJY5otM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libX11
    libXext
    libXpm
  ];

  meta = {
    description = "Clock dockapp for Window Maker";
    homepage = "https://www.dockapps.net/wmclock";
    license = lib.licenses.gpl2;
    mainProgram = "wmclock";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rem719 ];
  };
})
