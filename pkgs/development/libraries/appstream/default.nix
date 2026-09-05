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
  version = "1.2.2";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-asxvSjcMzx2upmyWJHvN4aqYU8RTQgsEDaJSEm8drG4=";
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
    cairo
    pango
    bash-completion
    vips
    wayland
  ]
  ++ lib.optionals withSystemd [
    systemdLibs
  ];

  mesonFlags = [
    (lib.mesonBool "apidocs" false)
    (lib.mesonBool "compose" true)
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
