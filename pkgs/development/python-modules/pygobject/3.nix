{ lib
, stdenv
, fetchurl
, buildPythonPackage
, pkg-config
, glib
, gobject-introspection
, pycairo
, cairo
, ncurses
, meson
, ninja
, isPy3k
, gnome
, python
}:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.42.2";

  outputs = [ "out" "dev" ];

  disabled = !isPy3k;

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "rehpXipwc4Sd0DFtMdhyjhXh4Lxx2f9tHAnoa+UryVc=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
  ];

  buildInputs = [
    # # .so files link to these
    gobject-introspection
    glib
  ] ++ lib.optionals stdenv.isDarwin [
    ncurses
  ];

  propagatedBuildInputs = [
    pycairo
    cairo
  ];

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    "-Dpython=${python.pythonForBuild.interpreter}"
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
