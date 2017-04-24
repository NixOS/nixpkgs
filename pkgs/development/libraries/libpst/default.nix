{ stdenv, fetchurl, autoreconfHook, boost, python2, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0.6.70";

  src = fetchurl {
      url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
      sha256 = "1m378vxh1sf9ry8k11x773xpy5f6cab5gkzqglz0jp9hc431r60r";
    };

  buildInputs = [ autoreconfHook boost python2 libgsf pkgconfig bzip2
    xmlto gettext imagemagick doxygen
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.five-ten-sg.com/libpst/;
    description = "A library to read PST (MS Outlook Personal Folders) files";
    license = licenses.gpl2;
    maintainers = [maintainers.tohl];
    platforms = platforms.unix;
  };
}
