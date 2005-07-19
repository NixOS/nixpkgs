{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-dynamic-2.3.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/stratego/aterm-2.3.2pre11645/aterm-2.3.2pre11645.tar.gz;
    md5 = "f2feeeee6498388911d69133bff83926";
  };
}
