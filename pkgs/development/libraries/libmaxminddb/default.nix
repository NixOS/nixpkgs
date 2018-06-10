{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmaxminddb-${version}";
  version = "1.3.2";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${name}.tar.gz";
    sha256 = "1w60yq26x3yr3abxk7fwqqaggw8dc98595jdliaa3kyqdfm83y76";
  };

  meta = with stdenv.lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = https://github.com/maxmind/libmaxminddb;
    license = licenses.apsl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
