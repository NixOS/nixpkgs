{ stdenv, fetchurl, pkgconfig, efl, python3Packages, dbus, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "econnman";
  version = "1.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/econnman/${pname}-${version}.tar.gz";
    sha256 = "057pwwavlvrrq26bncqnfrf449zzaim0zq717xv86av4n940gwv0";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig python3Packages.wrapPython ];

  buildInputs = [ efl python3Packages.python dbus ];

  pythonPath = [ python3Packages.pythonefl python3Packages.dbus-python ];

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "A user interface for the connman network connection manager";
    homepage = "https://enlightenment.org/";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
