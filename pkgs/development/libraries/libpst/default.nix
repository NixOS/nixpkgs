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
  pname = "libpst";
  version = "0.6.76";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${pname}-${version}.tar.gz";
    sha256 = "0hhbbb8ddsgjhv9y1xd8s9ixlhdnjmhw12v06jwx4j6vpgp1na9x";
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
