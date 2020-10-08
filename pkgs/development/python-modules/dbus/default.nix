{ lib, fetchPypi, buildPythonPackage, python, pkgconfig, dbus, dbus-glib, isPyPy
, ncurses, pygobject3 }:

buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.2.16";
  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "196m5rk3qzw5nkmgzjl7wmq0v7vpwfhh8bz2sapdi5f9hqfqy8qi";
  };

  patches = [
    ./fix-includedir.patch
  ];

  disabled = isPyPy;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus dbus-glib ]
    # My guess why it's sometimes trying to -lncurses.
    # It seems not to retain the dependency anyway.
    ++ lib.optional (! python ? modules) ncurses;

  doCheck = true;
  checkInputs = [ dbus.out pygobject3 ];

  meta = {
    description = "Python DBus bindings";
    license = lib.licenses.mit;
    platforms = dbus.meta.platforms;
  };
}
