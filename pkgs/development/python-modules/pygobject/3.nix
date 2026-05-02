{
  lib,
  stdenv,
  fetchurl,
  buildPythonPackage,
  pkg-config,
  glib,
  gobject-introspection,
  pycairo,
  cairo,
  ncurses,
  meson,
  ninja,
  gnome,
  python,

  withCairo ? true,
}:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.54.5";

  outputs = [
    "out"
    "dev"
  ];

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${lib.versions.majorMinor version}/pygobject-${version}.tar.gz";
    hash = "sha256-tmVvY0j1JFYGzxXqSMOEx/BRVsderSBsGyRsgKIvtYU=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
  ];

  buildInputs = [
    glib
  ]
  ++ lib.optionals withCairo [
    cairo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ ncurses ];

  propagatedBuildInputs = [
    gobject-introspection # e.g. try building: python3Packages.urwid python3Packages.pydbus
  ]
  ++ lib.optionals withCairo [
    pycairo
  ];

  # Fixes https://github.com/NixOS/nixpkgs/issues/378447
  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
    export PKG_CONFIG_PATH=${lib.getDev python}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH_FOR_BUILD=${lib.getDev python}/lib/pkgconfig:$PKG_CONFIG_PATH_FOR_BUILD
  '';

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    (lib.mesonOption "python" python.pythonOnBuildForHost.interpreter)

    (lib.mesonEnable "pycairo" withCairo)
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "pygobject";
      attrPath = "python3.pkgs.pygobject3";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for Glib";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
}
