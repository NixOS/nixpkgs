{ lib, stdenv, fetchurl
, cmake, docbook_xml_dtd_45, docbook_xsl, doxygen, graphviz-nox, pkg-config, qttools, wrapQtAppsHook
, alsa-lib, fluidsynth, libpulseaudio, qtbase, qtsvg, sonivox
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "2.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-5XxG5ur584fgW4oCONgMiWzV48Q02HEdmpb9+YhBFe0=";
  };

  patches = [
    ./drumstick-plugins.patch
  ];

  postPatch = ''
    substituteInPlace library/rt/backendmanager.cpp --subst-var out
  '';

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [
    cmake docbook_xml_dtd_45 docbook_xml_dtd_45 docbook_xsl doxygen graphviz-nox pkg-config qttools wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib fluidsynth libpulseaudio qtbase qtsvg sonivox
  ];

  cmakeFlags = [
    "-DUSE_DBUS=ON"
  ];

  meta = with lib; {
    maintainers = [];
    description = "MIDI libraries for Qt5/C++";
    homepage = "https://drumstick.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
