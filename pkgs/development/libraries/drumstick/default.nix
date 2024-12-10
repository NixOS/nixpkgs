{
  lib,
  stdenv,
  fetchurl,
  cmake,
  docbook_xml_dtd_45,
  docbook_xsl,
  doxygen,
  graphviz-nox,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  alsa-lib,
  fluidsynth,
  libpulseaudio,
  qtbase,
  qtsvg,
  sonivox,
  qt5compat ? null,
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "2.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-p0N8EeCtVEPCGzPwiRxPdI1XT5XQ5pcKYEDJXbYYTrM=";
  };

  patches = [
    ./drumstick-plugins.patch
  ];

  postPatch = ''
    substituteInPlace library/rt/backendmanager.cpp --subst-var out
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    docbook_xml_dtd_45
    docbook_xml_dtd_45
    docbook_xsl
    doxygen
    graphviz-nox
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    libpulseaudio
    qtbase
    qtsvg
    sonivox
  ] ++ lib.optionals isQt6 [ qt5compat ];

  cmakeFlags = [
    (lib.cmakeBool "USE_DBUS" true)
    (lib.cmakeBool "USE_QT5" (!isQt6))
  ];

  meta = with lib; {
    description = "MIDI libraries for Qt/C++";
    homepage = "https://drumstick.sourceforge.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
}
