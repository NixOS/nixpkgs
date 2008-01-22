args: with args;

stdenv.mkDerivation {
  name = "kdemultimedia-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdemultimedia-4.0.0.tar.bz2;
    sha256 = "14axr1x09k67vb3vaw4g9zg4mq7j14xn9d90kifwap7b76iljbi5";
  };

  propagatedBuildInputs = [kdeworkspace libogg flac cdparanoia lame libvorbis];
  buildInputs = [cmake];
}
