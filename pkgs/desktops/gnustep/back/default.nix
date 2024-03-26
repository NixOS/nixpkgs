{ lib
, stdenv
, make
, wrapGNUstepAppsHook
, cairo
, fetchzip
, base
, gui
, fontconfig
, freetype
, pkg-config
, libXft
, libXmu
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-back";
  version = "0.30.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HD4PLdkE573nPWqFwffUmcHw8VYIl5rLiPKWrbnwpCI=";
  };

  nativeBuildInputs = [ make pkg-config wrapGNUstepAppsHook ];
  buildInputs = [ cairo base gui fontconfig freetype libXft libXmu ];

  meta = {
    description = "A generic backend for GNUstep";
    mainProgram = "gpbs";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
