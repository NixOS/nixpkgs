{ lib, stdenv, fetchPypi, buildPythonPackage, python, pkg-config, dbus, dbus-glib, isPyPy
, ncurses, pygobject3, isPy3k }:

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

  preConfigure = if (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) then ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '' else null;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus dbus-glib ]
    # My guess why it's sometimes trying to -lncurses.
    # It seems not to retain the dependency anyway.
    ++ lib.optional (! python ? modules) ncurses;

  doCheck = isPy3k;
  checkInputs = [ dbus.out pygobject3 ];

  meta = {
    description = "Python DBus bindings";
    license = lib.licenses.mit;
    platforms = dbus.meta.platforms;
  };
}
