{ stdenv, fetchurl, pkgconfig, efl, elementary, python2Packages, dbus, makeWrapper }:
stdenv.mkDerivation rec {
  name = "econnman-${version}";
  version = "1.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/econnman/${name}.tar.gz";
    sha256 = "057pwwavlvrrq26bncqnfrf449zzaim0zq717xv86av4n940gwv0";
  };

  buildInputs = [ makeWrapper pkgconfig efl python2Packages.python python2Packages.wrapPython dbus ];
  pythonPath = [ python2Packages.pythonefl python2Packages.dbus elementary ];
  postInstall = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "A user interface for the connman network connection manager";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
