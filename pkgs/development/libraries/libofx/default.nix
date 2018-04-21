{ stdenv, fetchurl, opensp, pkgconfig, libxml2, curl }:
        
stdenv.mkDerivation rec {
  name = "libofx-0.9.12";

  src = fetchurl {
    url = "mirror://sourceforge/libofx/${name}.tar.gz";
    sha256 = "0wvkgffq9qjhjrggg8r1nbhmw65j3lcl4y4cdpmmkrqiz9ia0py1";
  };

  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ opensp libxml2 curl ];

  meta = { 
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = http://libofx.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}

