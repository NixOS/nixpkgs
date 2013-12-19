{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.9";
  
  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "0z4blmkyfjrkvgr12adjx7nnjrx4mvcm4zj8jp581m6rral7nf9y";
  };

  meta = {
    homepage = http://enet.bespin.org/;
    description = "Simple and robust network communication layer on top of UDP";
    license = "BSD";
  };
}
