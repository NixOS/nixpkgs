{stdenv, fetchurl, ncurses, readline
  , lib
  , zlib ? null
  , openssl ? null
}:

stdenv.mkDerivation {
  name = "ruby-1.8.6";
  src = fetchurl {
    url = ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.6.tar.gz;
    md5 = "23d2494aa94e7ae1ecbbb8c5e1507683";
  };

  buildInputs = [ncurses readline]
    ++(lib.optional (zlib != null) zlib)
    ++(lib.optional (openssl != null) openssl)
  ;
}
