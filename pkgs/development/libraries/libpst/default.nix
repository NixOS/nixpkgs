{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, bzip2
, doxygen
, gettext
, imagemagick
, libgsf
, xmlto
}:

stdenv.mkDerivation rec {
  name = "libpst-0.6.75";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
    sha256 = "11wrf47i3brlxg25wsfz17373q7m5fpjxn2lr41dj252ignqzaac";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    doxygen
    gettext
    xmlto
  ];

  buildInputs = [
    bzip2
    imagemagick
    libgsf
  ];

  configureFlags = [
    "--enable-python=no"
    "--disable-static"
    "--enable-libpst-shared"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.five-ten-sg.com/libpst/";
    description = "A library to read PST (MS Outlook Personal Folders) files";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tohl ];
    platforms = platforms.unix;
  };
}
