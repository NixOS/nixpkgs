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
  pythonOlder,
  gnome,
  python,
}:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.48.2";

  outputs = [
    "out"
    "dev"
  ];

  disabled = pythonOlder "3.8";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-B5SutKm+MaCSrCBiG19U7CgPkYWUPTKLEFza5imK0ac=";
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
  ] ++ lib.optionals stdenv.isDarwin [ ncurses ];

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
      packageName = pname;
      attrPath = "python3.pkgs.${pname}3";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for Glib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
