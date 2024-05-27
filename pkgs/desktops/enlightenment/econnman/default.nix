{ lib
, stdenv
, fetchurl
, makeWrapper
, pkg-config
, dbus
, efl
, python3Packages
, directoryListingUpdater
}:

stdenv.mkDerivation rec {
  pname = "econnman";
  version = "1.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/econnman/${pname}-${version}.tar.xz";
    sha256 = "sha256-DM6HaB+ufKcPHmPP4K5l/fF7wzRycFQxfiXjiXYZ7YU=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    dbus
    efl
    python3Packages.python
  ];

  pythonPath = [
    python3Packages.dbus-python
    python3Packages.pythonefl
  ];

  postInstall = ''
    wrapPythonPrograms
  '';

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "A user interface for the connman network connection manager";
    mainProgram = "econnman-bin";
    homepage = "https://enlightenment.org/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ matejc ftrvxmtrx ] ++ teams.enlightenment.members;
  };
}
