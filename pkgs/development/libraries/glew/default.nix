{ stdenv, fetchurl, mesa_glu, x11, libXmu, libXi }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "glew-1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${name}.tgz";
    sha256 = "01zki46dr5khzlyywr3cg615bcal32dazfazkf360s1znqh17i4r";
  };

  nativeBuildInputs = [ x11 libXmu libXi ];
  propagatedNativeBuildInputs = [ mesa_glu ]; # GL/glew.h includes GL/glu.h

  patchPhase = ''
    sed -i 's|lib64|lib|' config/Makefile.linux
  '';

  buildFlags = [ "all" ];
  installFlags = [ "install.all" ];

  preInstall = ''
    export GLEW_DEST="$out"
  '';

  postInstall = ''
    mkdir -pv $out/share/doc/glew
    mkdir -p $out/lib/pkgconfig
    cp glew*.pc $out/lib/pkgconfig
    cp -r README.txt LICENSE.txt doc $out/share/doc/glew
  '';

  crossAttrs.makeFlags = [
    "CC=${stdenv.cross.config}-gcc"
    "LD=${stdenv.cross.config}-gcc"
    "STRIP="
  ] ++ optional (stdenv.cross.libc == "msvcrt") "SYSTEM=mingw";

  meta = {
    description = "An OpenGL extension loading library for C(++)";
    homepage = http://glew.sourceforge.net/;
    license = ["BSD" "GLX" "SGI-B" "GPL2"]; # License description copied from gentoo-1.4.0 
  };
}
