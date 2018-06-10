{ lib, fetchurl, buildPythonPackage, python, pkgconfig, dbus, dbus-glib, dbus_tools, isPyPy
, ncurses, pygobject3 }:

if isPyPy then throw "dbus-python not supported for interpreter ${python.executable}" else buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.2.4";
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-python/${name}.tar.gz";
    sha256 = "1k7rnaqrk7mdkg0k6n2jn3d1mxsl7s3i07g5a8va5yvl3y3xdwg2";
  };

  postPatch = "patchShebangs .";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus dbus-glib ]
    ++ lib.optionals doCheck [ dbus_tools pygobject3 ]
    # My guess why it's sometimes trying to -lncurses.
    # It seems not to retain the dependency anyway.
    ++ lib.optional (! python ? modules) ncurses;

  doCheck = true;

  meta = {
    description = "Python DBus bindings";
    license = lib.licenses.mit;
    platforms = dbus.meta.platforms;
  };
}
