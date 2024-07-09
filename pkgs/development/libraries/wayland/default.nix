{ lib
, stdenv
, fetchurl
, meson
, pkg-config
, ninja
, wayland-scanner
, expat
, libxml2
, withLibraries ? stdenv.isLinux || stdenv.isDarwin
, withTests ? stdenv.isLinux
, libffi
, epoll-shim
, withDocumentation ? withLibraries && stdenv.hostPlatform == stdenv.buildPlatform
, graphviz-nox
, doxygen
, libxslt
, xmlto
, python3
, docbook_xsl
, docbook_xml_dtd_45
, docbook_xml_dtd_42
, testers
}:

# Documentation is only built when building libraries.
assert withDocumentation -> withLibraries;

# Tests are only built when building libraries.
assert withTests -> withLibraries;

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wayland";
  version = "1.22.0";

  src = fetchurl {
    url = with finalAttrs; "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
    hash = "sha256-FUCvHqaYpHHC2OnSiDMsfg/TYMjx0Sk267fny8JCWEI=";
  };

  patches = [
    ./darwin.patch
  ];

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
    "-Ddocumentation=${lib.boolToString withDocumentation}"
    "-Dlibraries=${lib.boolToString withLibraries}"
    "-Dtests=${lib.boolToString withTests}"
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
  ] ++ lib.optionals (withLibraries && !stdenv.hostPlatform.isLinux) [
    epoll-shim
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
    Version: ${finalAttrs.version}
    EOF
  '';

  passthru = {
    inherit withLibraries;
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Core Wayland window system code and protocol";
    mainProgram = "wayland-scanner";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos codyopel qyliss ];
    pkgConfigModules = [
      "wayland-scanner"
    ] ++ lib.optionals withLibraries [
      "wayland-client"
      "wayland-cursor"
      "wayland-egl"
      "wayland-egl-backend"
      "wayland-server"
    ];
  };
})
