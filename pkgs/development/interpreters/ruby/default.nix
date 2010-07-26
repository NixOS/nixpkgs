{ stdenv, fetchurl, ncurses, readline
, zlib ? null
, openssl ? null
, gdbm ? null
}:

stdenv.mkDerivation rec {
  version = "1.8.7-p299";
  
  name = "ruby-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/1.8/${name}.tar.gz";
    sha256 = "0ys2lpri2w3174axhi96vq17lrvk2ngj7f2m42a9008a7n79rj9j";
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
