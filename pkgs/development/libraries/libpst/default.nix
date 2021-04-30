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
  name = "libpst-0.6.76";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
    sha256 = "sha256-PSkb7rvbSNK5NGCLwGGVtkHaY9Ko9eDThvLp1tBaC0I=";
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
