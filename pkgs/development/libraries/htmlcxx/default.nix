{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "htmlcxx-${version}";
  version = "0.85";

  src = fetchurl {
    url = "mirror://sourceforge/htmlcxx/htmlcxx/${version}/${name}.tar.gz";
    sha256 = "1rdsjrcjkf7mi3182lq4v5wn2wncw0ziczagaqnzi0nwmp2a00mb";
  };

  patches = [ ./ptrdiff.patch ];

  meta = {
    homepage = http://htmlcxx.sourceforge.net/;
    description = "htmlcxx is a simple non-validating css1 and html parser for C++";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
