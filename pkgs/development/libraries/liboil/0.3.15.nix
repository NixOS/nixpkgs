args: with args;

stdenv.mkDerivation rec {
  name = "liboil-" + version;

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "1m3zcl54sf21cf2ckzny16ihymz8whi60ymyrhmd3m1dlw1knpmf";
  };

  configureFlags = "--enable-shared --disable-static";

  buildInputs = [pkgconfig glib];

  meta = {
    homepage = http://liboil.freedesktop.org;
    description = "Liboil is a library of simple functions that are optimized
    for various CPUs.";
  };
}
