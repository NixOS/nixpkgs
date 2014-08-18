{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.1.24";
  name = "libpaper-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/libp/libpaper/libpaper_${version}.tar.gz";
    sha256 = "0zhcx67afb6b5r936w5jmaydj3ks8zh83n9rm5sv3m3k8q8jib1q";
  };

  meta = {
    description = "Library for handling paper characteristics";
    homepage = "http://packages.debian.org/unstable/source/libpaper";
    license = "GPLv2";
  };
}
