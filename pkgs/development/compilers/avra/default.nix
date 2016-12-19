{ stdenv, fetchurl, autoconf, automake }:
stdenv.mkDerivation rec {
  name = "avra-1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/avra/${name}.tar.bz2";
    sha256 = "04lp0k0h540l5pmnaai07637f0p4zi766v6sfm7cryfaca3byb56";
  };

  buildInputs = [ autoconf automake ];

  preConfigure = ''
    cd src/

    aclocal
    autoconf

    touch NEWS README AUTHORS ChangeLog
    automake -a
  '';

  meta = with stdenv.lib; {
    description = "Assember for the Atmel AVR microcontroller family";
    homepage = http://avra.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ the-kenny ];
  };
}
