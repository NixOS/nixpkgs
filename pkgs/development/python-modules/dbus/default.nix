{ lib, fetchPypi, buildPythonPackage, python, pkgconfig, dbus, dbus-glib, isPyPy
, ncurses, pygobject3 }:

buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.2.12";
  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q7jmldv0bxxqnbj63cd7i81vs6y85xys4r0n63z4n2y9wndxm6d";
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
