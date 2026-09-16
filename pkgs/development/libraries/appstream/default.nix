{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.2.0";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HQIZbBhkWS8jhakMI3DmMP7Qi83JUnIqGJ2N3ddEWIE=";
  };

  patches = [
    (fetchpatch {
      name = "no-absolute-libstemmer-paths.patch";
      url = "https://github.com/ximion/appstream/commit/832c929031a124be07f6044d027ad2d8c35806d9.patch";
      hash = "sha256-uYOCE75jVy4euHZT2Xk/HdsOf1hGwkpZ8Fhtm7VKaIE=";
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
