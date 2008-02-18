args: with args;

stdenv.mkDerivation rec {
  name = "kdemultimedia-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "0njp8s4vmph6p0h740ynhfvnysmvin2ddpxwvxs9vzh7nd37izf0";
  };

  propagatedBuildInputs = [kde4.workspace libogg flac cdparanoia lame libvorbis];
  buildInputs = [cmake];
}
