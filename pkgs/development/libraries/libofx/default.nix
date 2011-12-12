{ stdenv, fetchurl, opensp, pkgconfig, libxml2, curl }:
        
stdenv.mkDerivation rec {
  name = "libofx-0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/libofx/${name}.tar.gz";
    sha256 = "1byvc1ar7s0nivi5cmycwlwh1y4xiad7ipfkgx57lbk7slgn8c4v";
  };

  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  buildInputs = [ opensp pkgconfig libxml2 curl ];

  meta = { 
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = http://libofx.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}

