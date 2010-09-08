{ stdenv, fetchurl
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
in

stdenv.mkDerivation rec {
  version = "1.8.7-p302";
  
  name = "ruby-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/1.8/${name}.tar.gz";
    sha256 = "18a4w0n1n0sij7gkb3196dnqav5zr0c5p26f08k7cw6y0i9dz0sq";
  };

  buildInputs = (ops cursesSupport [ ncurses readline ] )
    ++ (op docSupport groff )
    ++ (op zlibSupport zlib)
    ++ (op opensslSupport openssl)
    ++ (op gdbmSupport gdbm);
    
  configureFlags = ["--enable-shared" "--enable-pthread"];

  installFlags = stdenv.lib.optionalString docSupport "install-doc";

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
