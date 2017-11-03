{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmaxminddb-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${name}.tar.gz";
    sha256 = "0dxdyw6sxxmpzk2a96qp323r5kdmw7vm6m0l5a8gr52gf7nmks0z";
  };

  meta = with stdenv.lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = https://github.com/maxmind/libmaxminddb;
    license = licenses.apsl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
