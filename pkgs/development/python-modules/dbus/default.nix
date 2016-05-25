{ stdenv, fetchurl, python, pkgconfig, dbus, dbus_glib, dbus_tools, isPyPy
, ncurses }:

if isPyPy then throw "dbus-python not supported for interpreter ${python.executable}" else stdenv.mkDerivation rec {
  name = "dbus-python-1.2.4";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-python/${name}.tar.gz";
    sha256 = "1k7rnaqrk7mdkg0k6n2jn3d1mxsl7s3i07g5a8va5yvl3y3xdwg2";
  };

  postPatch = "patchShebangs .";

  buildInputs = [ python pkgconfig dbus dbus_glib ]
    ++ stdenv.lib.optional doCheck dbus_tools
    # My guess why it's sometimes trying to -lncurses.
    # It seems not to retain the dependency anyway.
    ++ stdenv.lib.optional (! python ? modules) ncurses;

  doCheck = true;

  # Set empty pythonPath, so that the package is recognized as a python package
  # for python.buildEnv
  pythonPath = [];

  meta = {
    description = "Python DBus bindings";
    license = stdenv.lib.licenses.mit;
    platforms = dbus.meta.platforms;
  };
}
