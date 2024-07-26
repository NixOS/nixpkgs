{ lib, stdenv, fetchPypi, buildPythonPackage, python, pkg-config, dbus, dbus-glib, isPyPy
, ncurses, pygobject3, isPy3k, pythonAtLeast }:

buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.2.18";

  # ModuleNotFoundError: No module named 'distutils'
  disabled = isPyPy || pythonAtLeast "3.12";
  format = "other";
  outputs = [ "out" "dev" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q3jrw515z98mqdk9x822nd95rky455zz9876f1nqna5igkd3gcj";
  };

  patches = [
    ./fix-includedir.patch
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  configureFlags = [
    "PYTHON=${python.pythonOnBuildForHost.interpreter}"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus dbus-glib ]
    # My guess why it's sometimes trying to -lncurses.
    # It seems not to retain the dependency anyway.
    ++ lib.optional (! python ? modules) ncurses;

  doCheck = isPy3k;
  nativeCheckInputs = [ dbus.out pygobject3 ];

  postInstall = ''
    cp -r dbus_python.egg-info $out/${python.sitePackages}/
  '';

  meta = with lib; {
    description = "Python DBus bindings";
    license = licenses.mit;
    platforms = dbus.meta.platforms;
    maintainers = with maintainers; [ ];
  };
}
