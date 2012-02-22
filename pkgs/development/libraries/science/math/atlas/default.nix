{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation {
  name = "atlas-3.9.67";
  
  src = fetchurl {
    url = mirror://sf/math-atlas/atlas3.9.67.tar.bz2;
    sha256 = "06xxlv440z8a3qmfrh17p28girv71c6awvpw5vhpspr0pcsgk1pa";
  };

  # configure outside of the source directory
  preConfigure = '' mkdir build; cd build; configureScript=../configure; '';

  # the manual says you should pass -fPIC as configure arg .. It works
  configureFlags = "-Fa alg -fPIC" + 
    (if stdenv.isi686 then " -b 32" else "");

  buildInputs = [ gfortran ];

  doCheck = true;

  meta = {
    description = "Atlas library";
    license = "GPL";
    homepage = http://math-atlas.sourceforge.net/;
  };
}
