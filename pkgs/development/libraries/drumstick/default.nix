{ stdenv, fetchurl
, cmake, docbook_xml_dtd_45, docbook_xsl, doxygen, pkg-config, wrapQtAppsHook
, alsaLib, fluidsynth, qtbase, qtsvg, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1n9wvg79yvkygrkc8xd8pgrd3d7hqmr7gh24dccf0px23lla9b3m";
  };

  patches = [
    ./drumstick-fluidsynth.patch
    ./drumstick-plugins.patch
  ];

  postPatch = ''
    substituteInPlace library/rt/backendmanager.cpp --subst-var out
  '';

  outputs = [ "out" "dev" "man" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake docbook_xml_dtd_45 docbook_xml_dtd_45 docbook_xsl doxygen pkg-config wrapQtAppsHook
  ];

  buildInputs = [
    alsaLib fluidsynth libpulseaudio qtbase qtsvg
  ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ solson ];
    description = "MIDI libraries for Qt5/C++";
    homepage = "http://drumstick.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
