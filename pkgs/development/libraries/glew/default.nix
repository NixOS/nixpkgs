{ stdenv, fetchurl, mesa, x11, libXmu, libXi }:

stdenv.mkDerivation rec {
  name = "glew-1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${name}.tgz";
    sha256 = "11xpmsw7m5qn7y8fa2ihhqcislz1bdd83mp99didd5ac84756dlv";
  };

  buildInputs = [ mesa x11 libXmu libXi ];

  installPhase = ''
    GLEW_DEST=$out make install
    mkdir -pv $out/share/doc/glew
    mkdir -p $out/lib/pkgconfig
    cp glew*.pc $out/lib/pkgconfig
    cp -r README.txt LICENSE.txt doc $out/share/doc/glew
  '';

  meta = {
    description = "An OpenGL extension loading library for C(++)";
    homepage = http://glew.sourceforge.net/;
    license = ["BSD" "GLX" "SGI-B" "GPL2"]; # License description copied from gentoo-1.4.0 
  };
}
