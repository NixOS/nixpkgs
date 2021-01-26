{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.5.0";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-fFbnkf8qZVIV5+04ZLH/3X00o4g1d57+1WpC8Fa9WKo=";
  };

  meta = with lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
