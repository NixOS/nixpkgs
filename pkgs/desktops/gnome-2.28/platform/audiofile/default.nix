{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "audiofile-0.2.6";
  src = fetchurl {
    url = mirror:/gnome/sources/audiofile/0.2/audiofile-0.2.6.tar.bz2;
    sha256 = "1d00w9hxx3flfs6cjyja99y8vpj1qwa34zfdj96dpa54drd9da62"
  };
}
