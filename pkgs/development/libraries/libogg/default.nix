{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libogg-1.2.0";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.gz";
    sha256 = "0sgbb7n8zwmycj2iid3h0hrxqg7ql9z34lg51bl99kca4cz9h3gk";
  };

  meta = {
    homepage = http://xiph.org/ogg/;
  };
}
