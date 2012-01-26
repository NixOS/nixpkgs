{ stdenv, fetchurl, mesa, x11, libXmu, libXi }:

stdenv.mkDerivation rec {
  name = "glew-1.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${name}.tgz";
    sha256 = "02aw6sc4v1434m7awfcxqb0v987i2ykg3fncnp21i9g1n4zsclqn";
  };

  buildInputs = [ mesa x11 libXmu libXi ];

  installPhase = "
    GLEW_DEST=\$out make install
    mkdir -pv \$out/share/doc/glew
    cp -r README.txt LICENSE.txt doc  \$out/share/doc/glew
  ";
  
  meta = { 
    description = "Cross-platform open-source C/C++ extension loading library";
    homepage = http://glew.sourceforge.net/;
    license = ["BSD" "GLX" "SGI-B" "GPL2"]; # License description copied from gentoo-1.4.0 
  };
}
