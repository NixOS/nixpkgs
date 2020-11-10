{ lib, stdenv, fetchurl, fetchpatch, meson, pkgconfig, ninja
, libffi, libxml2, wayland
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
, withDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform
, graphviz-nox, doxygen, libxslt, xmlto, python3
, docbook_xsl, docbook_xml_dtd_45, docbook_xml_dtd_42
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in stdenv.mkDerivation rec {
  pname = "wayland";
  version = "1.18.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0k995rn96xkplrapz5k648j651wc43kq817xk1x8280h16gsfxa6";
  };

  patches = [
    # Fix documentation to be reproducible.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/wayland/wayland/-/commit/e53e0edf0f892670f3e8c5dd527b3bb22335d32d.patch";
      sha256 = "15sbhi86m9k72lsj56p7zr20ph2b0y4svl639snsbafn2ir1zdb2";
    })
  ];

  outputs = [ "out" ] ++ lib.optionals withDocumentation [ "doc" "man" ];
  separateDebugInfo = true;

  mesonFlags = [ "-Ddocumentation=${lib.boolToString withDocumentation}" ];

  postPatch = lib.optionalString withDocumentation ''
    patchShebangs doc/doxygen/gen-doxygen.py
    substituteInPlace egl/meson.build --replace \
      "find_program('nm').path()" \
      "find_program('${stdenv.cc.targetPrefix}nm').path()"
  '';

  depsBuildBuild = [
    pkgconfig
  ];

  nativeBuildInputs = [
    meson pkgconfig ninja
  ] ++ lib.optionals isCross [
    wayland # For wayland-scanner during the build
  ] ++ lib.optionals withDocumentation [
    (graphviz-nox.override { pango = null; }) # To avoid an infinite recursion
    doxygen libxslt xmlto python3 docbook_xml_dtd_45
  ];

  buildInputs = [ libffi expat libxml2
  ] ++ lib.optionals withDocumentation [
    docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_42
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
    homepage    = "https://wayland.freedesktop.org/";
    license     = lib.licenses.mit; # Expat version
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ primeos codyopel ];
  };

  passthru.version = version;
}
