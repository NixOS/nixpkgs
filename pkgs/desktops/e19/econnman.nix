{ stdenv, fetchurl, pkgconfig, e19, python27, python27Packages, dbus, makeWrapper }:
stdenv.mkDerivation rec {
  name = "econnman-${version}";
  version = "1.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/econnman/${name}.tar.gz";
    sha256 = "057pwwavlvrrq26bncqnfrf449zzaim0zq717xv86av4n940gwv0";
  };

  buildInputs = [ makeWrapper pkgconfig e19.efl python27 dbus ];
  propagatedBuildInputs = [ python27Packages.pythonefl_1_13 python27Packages.dbus e19.elementary ];
  postInstall = ''
    wrapProgram $out/bin/econnman-bin --prefix PYTHONPATH : ${python27Packages.dbus}/lib/python2.7/site-packages:${python27Packages.pythonefl_1_13}/lib/python2.7/site-packages
  '';

  meta = {
    description = "Econnman is a user interface for the connman network connection manager";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
  };
}
