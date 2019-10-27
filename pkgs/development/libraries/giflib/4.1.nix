{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "giflib-4.1.6";

  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-4.1.6.tar.bz2;
    sha256 = "1v9b7ywz7qg8hli0s9vv1b8q9xxb2xvqq2mg1zpr73xwqpcwxhg1";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A library for reading and writing gif images";
    branch = "4.1";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

