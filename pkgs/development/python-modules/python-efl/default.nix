{
  lib,
  fetchurl,
  buildPythonPackage,
  pythonAtLeast,

  pkg-config,

  enlightenment,

  packaging,
  setuptools,

  dbus-python,

  directoryListingUpdater,
}:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.26.1";
  pyproject = true;

  # As of 1.26.1, native extensions fail to build with python 3.13+
  disabled = pythonAtLeast "3.13";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/python-efl-${version}.tar.xz";
    hash = "sha256-3Ns5fhIHihnpDYDnxvPP00WIZL/o1UWLzgNott4GKNc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ enlightenment.efl ];

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    dbus-python
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl evas) $NIX_CFLAGS_COMPILE"
  '';

  doCheck = false;

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Python bindings for Enlightenment Foundation Libraries";
    homepage = "https://github.com/DaveMDS/python-efl";
    platforms = platforms.linux;
    license = with licenses; [
      gpl3
      lgpl3
    ];
    maintainers = with maintainers; [
      matejc
      ftrvxmtrx
    ];
    teams = [ teams.enlightenment ];
  };
}
