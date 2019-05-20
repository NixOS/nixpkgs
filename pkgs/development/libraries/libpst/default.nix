{ stdenv, fetchurl, autoreconfHook, boost, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0.6.72";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
    sha256 = "01ymym0218805g7bqhr7x2rlhzsbsbidi3nr0z2r2w07xf8xh6ca";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    boost libgsf bzip2
    xmlto gettext imagemagick doxygen
  ];

  configureFlags = [
    "--enable-python=no"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.five-ten-sg.com/libpst/;
    description = "A library to read PST (MS Outlook Personal Folders) files";
    license = licenses.gpl2;
    maintainers = [maintainers.tohl];
    platforms = platforms.unix;
  };
}
