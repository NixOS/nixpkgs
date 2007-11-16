args: with args;

stdenv.mkDerivation {
  name = "kdemultimedia-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdemultimedia-3.95.0.tar.bz2;
    sha256 = "0vjk5gpn45fh7hm982jw1frd7fr0grff96ksmh29wnkc160rh8va";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace libogg flac cdparanoia lame
  libvorbis];
}
