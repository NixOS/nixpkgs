{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libx11,
  libxext,
  libxpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmclock";
  version = "1.0.16";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://www.dockapps.net/download/wmclock-${finalAttrs.version}.tar.gz";
    hash = "sha256-P4u13zFg1ZGdGc8m1FRJ5uEmDSovSF5h815kpJY5otM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libx11
    libxext
    libxpm
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
