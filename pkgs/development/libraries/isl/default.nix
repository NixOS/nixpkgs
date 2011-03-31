{stdenv, fetchurl, gmp, static ? false}:

let 
  version = "0.06";
  staticFlags = if static then " --enable-static --disable-shared" else "";
in

stdenv.mkDerivation {
  name = "isl-${version}";
  
  src = fetchurl {
    url = "http://www.kotnet.org/~skimo/isl/isl-${version}.tar.bz2";
    sha256 = "0w1i1m94w0jkmm0bzlp08c4r97j7yp0d7crxf28524b9mgbg0mwk";
  };

  buildInputs = [ gmp ];

  dontDisableStatic = if static then true else false;
  configureFlags = "--with-gmp-prefix=${gmp}" + staticFlags;

  meta = {
    homepage = http://www.kotnet.org/~skimo/isl/;
    license = "LGPLv2.1";
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints.";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}

