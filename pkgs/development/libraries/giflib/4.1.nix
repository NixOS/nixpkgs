{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "giflib-4.1.6";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-4.1.6.tar.bz2;
    sha256 = "1v9b7ywz7qg8hli0s9vv1b8q9xxb2xvqq2mg1zpr73xwqpcwxhg1";
  };
}

