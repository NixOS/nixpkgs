args: with args;

stdenv.mkDerivation rec {
  name = "liboil-" + version;

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0gdmly9sli1918pnb4ds1g38ipxikn651hdss86mp4qlfb8wvqlv";
  };

  configureFlags = "--enable-shared --disable-static";

  buildInputs = [pkgconfig];

  meta = {
    homepage = http://liboil.freedesktop.org;
    description = "Liboil is a library of simple functions that are optimized
    for various CPUs.";
  };
}
