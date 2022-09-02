{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.6.0";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-diCsGHxZHOIbzXvzUjdqPFapM+aEVYofa+9L1PP5gmc=";
  };

  meta = with lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = licenses.asl20;
    maintainers = [ maintainers.ajs124 ];
    mainProgram = "mmdblookup";
    platforms = platforms.all;
  };
}
