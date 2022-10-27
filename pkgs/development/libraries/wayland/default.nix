{ lib
, stdenv
, fetchurl
, substituteAll
, meson
, pkg-config
, ninja
, wayland-scanner
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
  version = "1.21.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
    sha256 = "1b0ixya9bfw5c9jx8mzlr7yqnlyvd3jv5z8wln9scdv8q5zlvikd";
  };

  postPatch = lib.optionalString withDocumentation ''
    patchShebangs doc/doxygen/gen-doxygen.py
  '' + lib.optionalString stdenv.hostPlatform.isStatic ''
    # delete line containing os-wrappers-test, disables
    # the building of os-wrappers-test
    sed -i '/os-wrappers-test/d' tests/meson.build
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
    wayland-scanner
  ] ++ lib.optionals withDocumentation [
    (graphviz-nox.override { pango = null; }) # To avoid an infinite recursion
    doxygen
    libxslt
    xmlto
    python3
    docbook_xml_dtd_45
    docbook_xsl
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

  postFixup = ''
    # The pkg-config file is required for cross-compilation:
    mkdir -p $bin/lib/pkgconfig/
    cat <<EOF > $bin/lib/pkgconfig/wayland-scanner.pc
    wayland_scanner=$bin/bin/wayland-scanner

    Name: Wayland Scanner
    Description: Wayland scanner
    Version: ${version}
    EOF
  '';

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
    # big sur doesn't support gcc stdenv and wayland doesn't build with clang
    broken = stdenv.isDarwin;
  };

  passthru.version = version;
}
