{
  lib,
  stdenv,
  fetchurl,
  imake,
  gccmakedep,
  libXt,
  libXext,
}:

stdenv.mkDerivation rec {
  pname = "xearth";
  version = "1.1";

  src = fetchurl {
    url = "http://xearth.org/${pname}-${version}.tar.gz";
    sha256 = "bcb1407cc35b3f6dd3606b2c6072273b6a912cbd9ed1ae22fb2d26694541309c";
  };

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libXt
    libXext
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

  meta = with lib; {
    description = "sets the X root window to an image of the Earth";
    mainProgram = "xearth";
    homepage = "https://xearth.org";
    longDescription = ''
      Xearth  sets  the X root window to an image of the Earth, as seen from your favorite vantage point in space,
      correctly shaded for the current position of the Sun.
      By default, xearth updates the displayed image every  five  minutes.
    '';
    maintainers = [ maintainers.mafo ];
    license = {
      fullName = "xearth license";
      url = "https://xearth.org/copyright.html";
      free = true;
    };
    platforms = platforms.unix;
  };

}
