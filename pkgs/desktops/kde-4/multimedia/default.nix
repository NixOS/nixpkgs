args: with args;

stdenv.mkDerivation {
  name = "kdemultimedia-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdemultimedia-4.0.0.tar.bz2;
    md5 = "0bf1cd18a23017a37324d9f8c4902e19";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace libogg flac cdparanoia lame
  libvorbis];
}
