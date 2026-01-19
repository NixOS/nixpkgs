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
    cairo
    glib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ ncurses ];

  propagatedBuildInputs = [
    pycairo
    gobject-introspection # e.g. try building: python3Packages.urwid python3Packages.pydbus
  ];

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    "-Dpython=${python.pythonOnBuildForHost.interpreter}"
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
