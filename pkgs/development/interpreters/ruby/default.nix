{ stdenv, fetchurl, ncurses, readline
, zlib ? null
, openssl ? null
, gdbm ? null
}:

stdenv.mkDerivation rec {
  version = "1.8.7-p72";
  
  name = "ruby-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/1.8/${name}.tar.gz";
    sha256 = "e15ca005076f5d6f91fc856fdfbd071698a4cadac3c6e25855899dba1f6fc5ef";
  };

  buildInputs = [ncurses readline]
    ++ (stdenv.lib.optional (zlib != null) zlib)
    ++ (stdenv.lib.optional (openssl != null) openssl)
    ++ (stdenv.lib.optional (gdbm != null) gdbm);
    
  configureFlags = ["--enable-shared" "--enable-pthread"];

  # NIX_LDFLAGS = "-lpthread -lutil";

  meta = {
    license = "Ruby";
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
  };

  passthru = {
    # install ruby libs into "$out/${ruby.libPath}"
    libPath = "lib/ruby-1.8";
  };
}
