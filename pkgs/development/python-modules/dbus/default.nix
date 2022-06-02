{ lib, stdenv, fetchPypi, buildPythonPackage, python, pkg-config, dbus, dbus-glib, isPyPy
, ncurses, pygobject3, isPy3k }:

buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.2.18";
  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q3jrw515z98mqdk9x822nd95rky455zz9876f1nqna5igkd3gcj";
  };

  patches = [
    ./fix-includedir.patch
  ];

  disabled = isPyPy;

  preConfigure = if (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) then ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '' else null;

  configureFlags = [
    "PYTHON=${python.pythonForBuild.interpreter}"
  ];

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
