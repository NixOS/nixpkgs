{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.4.2";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0mnimbaxnnarlw7g1rh8lpxsyf7xnmzwcczcc3lxw8xyf6ljln6x";
  };

  meta = with stdenv.lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = https://github.com/maxmind/libmaxminddb;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
