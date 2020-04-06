{ stdenv, fetchurl, autoreconfHook, boost, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0.6.74";

  src = fetchurl {
    url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
    sha256 = "0dzx8jniz7mczbbp08zfrl46h27hyfrsnjxmka9pi5aawzfdm1zp";
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
