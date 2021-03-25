{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, pkg-config
, substituteAll
, ninja
, libffi
, libxml2
, wayland
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
, withDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform
, graphviz-nox
, doxygen
, libxslt
, xmlto
, python3
, docbook_xsl
, docbook_xml_dtd_45
, docbook_xml_dtd_42
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;
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

  outputs = [ "out" ] ++ lib.optionals withDocumentation [ "doc" "man" ];
  separateDebugInfo = true;

  mesonFlags = [ "-Ddocumentation=${lib.boolToString withDocumentation}" ];

  postPatch = lib.optionalString withDocumentation ''
    patchShebangs doc/doxygen/gen-doxygen.py
  '';

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
    libffi
    expat
    libxml2
  ] ++ lib.optionals withDocumentation [
    docbook_xsl
    docbook_xml_dtd_45
    docbook_xml_dtd_42
  ];

  meta = {
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
    license = lib.licenses.mit; # Expat version
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ primeos codyopel ];
  };

  passthru.version = version;
}
