{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.5.2";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-UjcHbSUKX3wpfjMcNaQz7qrw3CBeBw5Ns1PJuhDzQKI=";
  };

  meta = with lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
