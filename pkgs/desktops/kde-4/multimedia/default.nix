args: with args;

stdenv.mkDerivation {
  name = "kdemultimedia-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdemultimedia-3.97.0.tar.bz2;
    sha256 = "0q78d1gh5na72aj604myy23qn6xb0izw0igsi1h9i4pc2bsis87i";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace libogg flac cdparanoia lame
  libvorbis];
}
