{ stdenv, fetchurl, autoreconfHook, boost, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0.6.71";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
    sha256 = "130nksrwgi3ih32si5alvxwzd5kmlg8yi7p03w0h7w9r3b90i4pv";
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
