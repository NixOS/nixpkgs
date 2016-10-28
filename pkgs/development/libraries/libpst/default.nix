{ stdenv, fetchurl, autoreconfHook, boost, python2, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0.6.68";

  src = fetchurl {
      url = "http://www.five-ten-sg.com/libpst/packages/${name}.tar.gz";
      sha256 = "06mcaga36i65n1ifr5pw6ghcb1cjfqwrmm1xmaw1sckqf2iqx2by";
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
