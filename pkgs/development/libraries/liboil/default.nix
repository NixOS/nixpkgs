{stdenv, fetchurl, pkgconfig, glib, ...}:

stdenv.mkDerivation rec {
  name = "liboil-0.3.15";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "1m3zcl54sf21cf2ckzny16ihymz8whi60ymyrhmd3m1dlw1knpmf";
  };

  buildInputs = [pkgconfig glib];

  meta = {
    homepage = http://liboil.freedesktop.org;
    description = "A library of simple functions that are optimized for various CPUs";
  };
}
