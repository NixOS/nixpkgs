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
  version = "1.23.1";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
    hash = "sha256-hk+yqDmeLQ7DnVbp2bdTwJN3W+rcYCLOgfRBkpqB5e0=";
  };

  patches = [
    ./darwin.patch
  ];

  postPatch =
    lib.optionalString withDocumentation ''
      patchShebangs doc/doxygen/gen-doxygen.py
    ''
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      # delete line containing os-wrappers-test, disables
      # the building of os-wrappers-test
      sed -i '/os-wrappers-test/d' tests/meson.build
    '';

  outputs =
    [
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

  nativeBuildInputs =
    [
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

  buildInputs =
    [
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
    maintainers = with maintainers; [
      primeos
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
