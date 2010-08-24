{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.0";
  
  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "0b6nv3q546mr1vr74jccd4nsad9zkmjn17kdrqxxnyc944djf310";
  };

  meta = {
    homepage = http://enet.bespin.org/;
    description = "Simple and robust network communication layer on top of UDP";
    license = "BSD";
  };
}
