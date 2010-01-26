{ stdenv, fetchurl, opensp, pkgconfig, libxml2, curl }:
        
stdenv.mkDerivation rec {
  name = "libofx-0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/libofx/${name}.tar.gz";
    sha256 = "0gyana7v3pcqdpncjr5vg5z2r2z3rvg0fiml59mazi9n62zk86rj";
  };

  patches = [ ./libofx-0.9.0-gcc43.patch ];

  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  buildInputs = [ opensp pkgconfig libxml2 curl ];

  meta = { 
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = http://libofx.sourceforge.net/;
    license = "LGPL";
  };
}

