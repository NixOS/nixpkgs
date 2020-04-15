{ stdenv, fetchurl, autoreconfHook, boost, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0.6.75";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
    sha256 = "11wrf47i3brlxg25wsfz17373q7m5fpjxn2lr41dj252ignqzaac";
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
    homepage = "https://www.five-ten-sg.com/libpst/";
    description = "A library to read PST (MS Outlook Personal Folders) files";
    license = licenses.gpl2;
    maintainers = [maintainers.tohl];
    platforms = platforms.unix;
  };
}
