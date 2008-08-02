{stdenv, fetchurl, ncurses, readline
  , lib
  , zlib ? null
  , openssl ? null
}:

stdenv.mkDerivation rec {
  version = "1.8.7-p22";
  name = "ruby-${version}";
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/${name}.tar.gz";
    sha256 = "0wn04bzmgmn2bvpwjh3b403dp3iqiygd75s76136h1khy6lydr6j";
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
