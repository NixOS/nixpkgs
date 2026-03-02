{
  lib,
  stdenv,
  fetchurl,
  imake,
  gccmakedep,
  libxt,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xearth";
  version = "1.1";

  src = fetchurl {
    url = "http://xearth.org/xearth-${finalAttrs.version}.tar.gz";
    hash = "sha256-vLFAfMNbP23TYGssYHInO2qRLL2e0a4i+y0maUVBMJw=";
  };

  postPatch = "sed -i '48i #include <stdlib.h>' gifout.c";

  nativeBuildInputs = [
    imake
    gccmakedep
  ];

  buildInputs = [
    libxt
    libxext
  ];

  installFlags = [
    "DESTDIR=$(out)/"
    "BINDIR=bin"
    "MANDIR=man/man1"
  ];

  installTargets = [
    "install"
    "install.man"
  ];

  meta = {
    description = "Set the X root window to an image of the Earth";
    mainProgram = "xearth";
    homepage = "https://xearth.org";
    longDescription = ''
      Xearth  sets  the X root window to an image of the Earth, as seen from your favorite vantage point in space,
      correctly shaded for the current position of the Sun.
      By default, xearth updates the displayed image every  five  minutes.
    '';
    maintainers = with lib.maintainers; [ mafo ];
    license = {
      fullName = "xearth license";
      url = "https://xearth.org/copyright.html";
      free = true;
    };
    platforms = lib.platforms.unix;
  };
})
