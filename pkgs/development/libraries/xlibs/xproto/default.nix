{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xproto-6.6.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/xproto-6.6.1.tar.bz2;
    md5 = "8a7546a607dcd61b2ee595c763fd7f85";
  };
}
