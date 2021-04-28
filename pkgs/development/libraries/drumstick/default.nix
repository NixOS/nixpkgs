{ lib, stdenv, fetchurl
, cmake, docbook_xml_dtd_45, docbook_xsl, doxygen, graphviz-nox, pkg-config, qttools, wrapQtAppsHook
, alsaLib, fluidsynth, qtbase, qtsvg, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    sha256 = "06lz4kzpgg5lalcjb14pi35jxca5f4j6ckqf6mdxs1k42dfhjpjp";
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
    alsaLib fluidsynth libpulseaudio qtbase qtsvg
  ];

  cmakeFlags = [
    "-DUSE_DBUS=ON"
  ];

  meta = with lib; {
    maintainers = with maintainers; [ solson ];
    description = "MIDI libraries for Qt5/C++";
    homepage = "http://drumstick.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
