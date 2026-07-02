{
  lib,
  stdenv,
  buildPackages,
  replaceVars,
  fetchFromGitHub,
  meson,
  mesonEmulatorHook,
  appstream,
  ninja,
  pkg-config,
  cmake,
  gettext,
  xmlto,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  libxslt,
  libstemmer,
  glib,
  xapian,
  libxml2,
  libxmlb,
  libfyaml,
  gobject-introspection,
  itstool,
  gperf,
  vala,
  curl,
  cairo,
  gdk-pixbuf,
  pango,
  librsvg,
  bash-completion,
  systemd,
  nixosTests,
  testers,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appstream";
  version = "1.1.2";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tvdWWdL6PthffAZZnNZ3+17/eJdZFx8xFkqm7IvyPWE=";
  };

  patches = [
    # Fix hardcoded paths
    (replaceVars ./fix-paths.patch {
      libstemmer_includedir = "${lib.getDev libstemmer}/include";
    })

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
    docbook-xsl-nons
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
    libstemmer
    glib
    xapian
    libxml2
    libxmlb
    libfyaml
    curl
    cairo
    gdk-pixbuf
    pango
    librsvg
    bash-completion
  ]
  ++ lib.optionals withSystemd [
    systemd
  ];

  mesonFlags = [
    "-Dapidocs=false"
    "-Dc_args=-Wno-error=missing-include-dirs"
    "-Ddocs=false"
    "-Dvapi=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Dcompose=true"
    (lib.mesonBool "gir" withIntrospection)
  ]
  ++ lib.optionals (!withSystemd) [
    "-Dsystemd=false"
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
