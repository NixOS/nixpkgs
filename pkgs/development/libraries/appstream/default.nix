{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  meson,
  mesonEmulatorHook,
  appstream,
  ninja,
  pkg-config,
  cmake,
  gettext,
  xmlto,
  docbook-xsl-ns,
  docbook_xml_dtd_45,
  libblake3,
  libxslt,
  libstemmer,
  glib,
  libxml2,
  libxmlb,
  libfyaml,
  gobject-introspection,
  itstool,
  gperf,
  vala,
  curl,
  cairo,
  pango,
  bash-completion,
  vips,
  wayland,
  systemdLibs,
  nixosTests,
  testers,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appstream";
  version = "1.2.3";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SNVM2luS/bgxg0JfxuSQNel3SaKTu9ZTbJ14vV8V1jo=";
  };

  patches = [
    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    gettext
    libxslt
    xmlto
    docbook-xsl-ns
    docbook_xml_dtd_45
    glib
    itstool
    gperf
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ]
  ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
    appstream
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ];

  buildInputs = [
    libblake3
    libstemmer
    glib
    libxml2
    libxmlb
    libfyaml
    curl
    bash-completion
  ]
  # only used by appstream-compose
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    cairo
    pango
    vips
    wayland
  ]
  ++ lib.optionals withSystemd [
    systemdLibs
  ];

  mesonFlags = [
    (lib.mesonBool "apidocs" false)
    # uses Linux-specific APIs
    (lib.mesonBool "compose" stdenv.hostPlatform.isLinux)
    (lib.mesonBool "docs" false)
    (lib.mesonBool "gir" withIntrospection)
    (lib.mesonBool "systemd" withSystemd)
    (lib.mesonBool "vapi" true)
    (lib.mesonOption "c_args" "-Wno-error=missing-include-dirs")
    (lib.mesonOption "installed_test_prefix" "${placeholder "installedTests"}")
  ];

  passthru.tests = {
    installed-tests = nixosTests.installed-tests.appstream;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Software metadata handling library";
    longDescription = ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    homepage = "https://www.freedesktop.org/wiki/Distributions/AppStream/";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "appstreamcli";
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "appstream" ];
  };
})
