args: with args;

stdenv.mkDerivation rec {
  name = "liboil-" + version;

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0cndfz98zca40qc1d2waq1dkfx32yscbllbvlnlhjp4cjlkyh9qg";
  };

  configureFlags = "--enable-shared --disable-static";

  buildInputs = [pkgconfig glib];

  meta = {
    homepage = http://liboil.freedesktop.org;
    description = "A library of simple functions that are optimized for various CPUs";
  };
}
