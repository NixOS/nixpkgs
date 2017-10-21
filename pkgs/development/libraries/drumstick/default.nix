{ stdenv, fetchurl, alsaLib, cmake, docbook_xsl, docbook_xml_dtd_45, doxygen
, fluidsynth, pkgconfig, qt5
}:

stdenv.mkDerivation rec {
  name = "drumstick-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${name}.tar.bz2";
    sha256 = "13pkfqrav30bbcddgf1imd7jk6lpqbxkz1qv31718pdl446jq7df";
  };

  outputs = [ "out" "dev" "man" ];

  enableParallelBuilding = true;

  #Temporarily remove drumstick-piano; Gives segment fault. Submitted ticket
  postInstall = ''
    rm $out/bin/drumstick-vpiano
    '';

  nativeBuildInputs = [ cmake pkgconfig docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_45 ];
  buildInputs = [
    alsaLib doxygen fluidsynth qt5.qtbase qt5.qtsvg
  ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ solson ];
    description = "MIDI libraries for Qt5/C++";
    homepage = http://drumstick.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
