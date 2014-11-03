{ stdenv, fetchurl, pkgconfig, e18, python27, python27Packages, dbus, makeWrapper }:
stdenv.mkDerivation rec {
  name = "econnman-${version}";
  version = "1.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/econnman/${name}.tar.gz";
    sha256 = "057pwwavlvrrq26bncqnfrf449zzaim0zq717xv86av4n940gwv0";
  };

  buildInputs = [ makeWrapper pkgconfig e18.efl python27 dbus ];
  propagatedBuildInputs = [ python27Packages.pythonefl python27Packages.dbus e18.elementary ];
  postInstall = ''
    wrapProgram $out/bin/econnman-bin --prefix PYTHONPATH : ${python27Packages.dbus}/lib/python2.7/site-packages:${python27Packages.pythonefl}/lib/python2.7/site-packages
  '';

  meta = {
    description = "Econnman is a user interface for the connman network connection manager";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
