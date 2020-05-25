{ stdenv, fetchurl, alsaLib, cmake, docbook_xsl, docbook_xml_dtd_45, doxygen
, fluidsynth, pkgconfig, qt5
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1n9wvg79yvkygrkc8xd8pgrd3d7hqmr7gh24dccf0px23lla9b3m";
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
    homepage = "http://drumstick.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
