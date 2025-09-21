{
  lib,
  stdenv,
  fetchurl,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  withTests ? stdenv.hostPlatform.isLinux,
  libffi,
  epoll-shim,
  withDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  graphviz-nox,
  doxygen,
  libxslt,
  xmlto,
  python3,
  docbook_xsl,
  docbook_xml_dtd_45,
  docbook_xml_dtd_42,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland";
  version = "1.24.0";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
    hash = "sha256-gokkh6Aa1nszTsqDtUMXp8hqA6ic+trP71IR8RpdBTY=";
  };

  patches = [
    ./darwin.patch
  ];

  postPatch = lib.optionalString withDocumentation ''
    patchShebangs doc/doxygen/gen-doxygen.py
  '';

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
    "man"
  ];
  separateDebugInfo = true;

  mesonFlags = [
    (lib.mesonBool "documentation" withDocumentation)
    (lib.mesonBool "tests" withTests)
    (lib.mesonBool "scanner" false) # wayland-scanner is a separate derivation
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wayland-scanner
  ]
  ++ lib.optionals withDocumentation [
    (graphviz-nox.override { pango = null; }) # To avoid an infinite recursion
    doxygen
    libxslt
    xmlto
    python3
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    libffi
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    epoll-shim
  ]
  ++ lib.optionals withDocumentation [
    docbook_xsl
    docbook_xml_dtd_45
    docbook_xml_dtd_42
  ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

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
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # requires more work: https://gitlab.freedesktop.org/wayland/wayland/-/merge_requests/481
    maintainers = with maintainers; [
      codyopel
      qyliss
    ];
    pkgConfigModules = [
      "wayland-client"
      "wayland-cursor"
      "wayland-egl"
      "wayland-egl-backend"
      "wayland-server"
    ];
  };
})
