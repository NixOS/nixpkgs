{stdenv, fetchurl, cmake, zlib, libxml2, eigen, python }:

stdenv.mkDerivation rec {
  name = "openbabel-2.3.0";
  
  src = fetchurl { 
    url = "mirror://sourceforge/openbabel/${name}.tar.gz";
    sha256 = "1yv1z04il8q6nhcc3l9019aj7nzs3bfm667s2vkg5cc3dljwpbbd";
  };
  
  # TODO : perl & python bindings;
  # TODO : wxGTK: I have no time to compile
  # TODO : separate lib and apps
  buildInputs = [ zlib libxml2 eigen python ];

  buildNativeInputs = [ cmake ];

  meta = {
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
