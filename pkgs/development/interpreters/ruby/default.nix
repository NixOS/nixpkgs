{stdenv, fetchurl, ncurses, readline
  , lib
  , zlib ? null
  , openssl ? null
  , makeOverridable
}:

makeOverridable (stdenv.mkDerivation) rec {
  version = "1.8.7-p72";
  name = "ruby-${version}";
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/1.8/${name}.tar.gz";
    sha256 = "e15ca005076f5d6f91fc856fdfbd071698a4cadac3c6e25855899dba1f6fc5ef";
  };

  buildInputs = [ncurses readline]
    ++(lib.optional (zlib != null) zlib)
    ++(lib.optional (openssl != null) openssl)
  ;
  configureFlags = ["--enable-shared" "--enable-pthread"] ;


  # NIX_LDFLAGS = "-lpthread -lutil";

  meta = {
    license = "Ruby";
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
  };
}
