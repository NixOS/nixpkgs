{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.1";
  
  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "1faszy5jvxcbjvnqzxaxpcm0rh8xib52pgn2zm1vyc9gg957hw99";
  };

  meta = {
    homepage = http://enet.bespin.org/;
    description = "Simple and robust network communication layer on top of UDP";
    license = "BSD";
  };
}
