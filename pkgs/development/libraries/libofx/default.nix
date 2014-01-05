{ stdenv, fetchurl, opensp, pkgconfig, libxml2, curl }:
        
stdenv.mkDerivation rec {
  name = "libofx-0.9.9";

  src = fetchurl {
    url = "mirror://sourceforge/libofx/${name}.tar.gz";
    sha256 = "08vvfj1rq0drcdfchrgb5zp05a2xl3a5aapsfgj0gqy3rp2qivwl";
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

