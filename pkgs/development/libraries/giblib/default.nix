{ stdenv, fetchurl, xlibsWrapper, imlib2 }:

stdenv.mkDerivation rec {
  name = "giblib-1.2.4";
  
  src = fetchurl {
    url = "http://linuxbrit.co.uk/downloads/${name}.tar.gz";
    sha256 = "1b4bmbmj52glq0s898lppkpzxlprq9aav49r06j2wx4dv3212rhp";
  };
  
  buildInputs = [xlibsWrapper imlib2];

  meta = {
    homepage = http://linuxbrit.co.uk/giblib/;
    platforms = stdenv.lib.platforms.unix;
  };
}
