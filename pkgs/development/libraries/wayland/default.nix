{ lib
, stdenv
, fetchurl
, substituteAll
, meson
, pkg-config
, ninja
, wayland
, expat
, libxml2
, withLibraries ? stdenv.isLinux
, libffi
, withDocumentation ? withLibraries && stdenv.hostPlatform == stdenv.buildPlatform
, graphviz-nox
, doxygen
, libxslt
, xmlto
, python3
, docbook_xsl
, docbook_xml_dtd_45
, docbook_xml_dtd_42
}:

# Documentation is only built when building libraries.
assert withDocumentation -> withLibraries;

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in
stdenv.mkDerivation rec {
  pname = "wayland";
  version = "1.19.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "05bd2vphyx8qwa1mhsj1zdaiv4m4v94wrlssrn0lad8d601dkk5s";
  };

  patches = [
    (substituteAll {
      src = ./0001-add-placeholder-for-nm.patch;
      nm = "${stdenv.cc.targetPrefix}nm";
    })
  ];

  postPatch = lib.optionalString withDocumentation ''
    patchShebangs doc/doxygen/gen-doxygen.py
  '';

  outputs = [ "out" "bin" "dev" ] ++ lib.optionals withDocumentation [ "doc" "man" ];
  separateDebugInfo = true;

  mesonFlags = [
    "-Dlibraries=${lib.boolToString withLibraries}"
    "-Ddocumentation=${lib.boolToString withDocumentation}"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ] ++ lib.optionals isCross [
    wayland # For wayland-scanner during the build
  ] ++ lib.optionals withDocumentation [
    (graphviz-nox.override { pango = null; }) # To avoid an infinite recursion
    doxygen
    libxslt
    xmlto
    python3
    docbook_xml_dtd_45
  ];

  buildInputs = [
    expat
    libxml2
  ] ++ lib.optionals withLibraries [
    libffi
  ] ++ lib.optionals withDocumentation [
    docbook_xsl
    docbook_xml_dtd_45
    docbook_xml_dtd_42
  ];

  meta = with lib; {
    description = "Core Wayland window system code and protocol";
    longDescription = ''
      Wayland is a project to define a protocol for a compositor to talk to its
      clients as well as a library implementation of the protocol.
      The wayland protocol is essentially only about input handling and buffer
      management, but also handles drag and drop, selections, window management
      and other interactions that must go through the compositor (but not
      rendering).
    '';
    homepage = "https://wayland.freedesktop.org/";
    license = licenses.mit; # Expat version
    platforms = if withLibraries then platforms.linux else platforms.unix;
    maintainers = with maintainers; [ primeos codyopel qyliss ];
  };

  passthru.version = version;
}
