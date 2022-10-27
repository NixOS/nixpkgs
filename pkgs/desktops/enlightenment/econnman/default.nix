{ lib
, stdenv
, fetchurl
, makeWrapper
, pkg-config
, dbus
, efl
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "econnman";
  version = "1.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/econnman/${pname}-${version}.tar.gz";
    sha256 = "057pwwavlvrrq26bncqnfrf449zzaim0zq717xv86av4n940gwv0";
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

  meta = with lib; {
    description = "A user interface for the connman network connection manager";
    homepage = "https://enlightenment.org/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ matejc ftrvxmtrx ] ++ teams.enlightenment.members;
  };
}
