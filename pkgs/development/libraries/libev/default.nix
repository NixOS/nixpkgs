{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libev-${version}";
  version="4.15";
  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${name}.tar.gz";
    sha256 = "1svgc1hq4i5zsw4i02sf7xb4pk2d8kpvc1gdrd856vsmffh47pdj";
  };
  meta = {
    description = "An event loop library remotely similar to libevent";
    maintainers = [
      stdenv.lib.maintainers.raskin
    ];
    platforms = stdenv.lib.platforms.all;
  };
}
