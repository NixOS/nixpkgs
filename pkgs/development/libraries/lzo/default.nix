{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "lzo-2.03";
  
  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "8b1b0da8f757b9ac318e1c15a0eac8bdb56ca902a2dd25beda06c0f265f22591";
  };

  configureFlags = "--enable-shared";

  meta = {
    description = "A data compresion library suitable for real-time data de-/compression";
    homepage = http://www.oberhumer.com/opensource/lzo;
    license = "GPLv2+";
  };
}
