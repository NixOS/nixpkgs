{ stdenv, fetchurl, opensp, pkgconfig, libxml2, curl }:
        
stdenv.mkDerivation rec {
  name = "libofx-0.9.10";

  src = fetchurl {
    url = "mirror://sourceforge/libofx/${name}.tar.gz";
    sha256 = "15gnbh4mszfxk70srdcjkdykk7dbhzqxi3pxgh48a9zg8i4nmqjl";
  };

  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  buildInputs = [ opensp pkgconfig libxml2 curl ];

  meta = { 
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = http://libofx.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}

