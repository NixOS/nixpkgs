{ stdenv, fetchurl, mesa_glu, xlibsWrapper, libXmu, libXi }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "glew-1.13.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${name}.tgz";
    sha256 = "1iwb2a6wfhkzv6fa7zx2gz1lkwa0iwnd9ka1im5vdc44xm4dq9da";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [ xlibsWrapper libXmu libXi ];
  propagatedNativeBuildInputs = [ mesa_glu ]; # GL/glew.h includes GL/glu.h

  patchPhase = ''
    sed -i 's|lib64|lib|' config/Makefile.linux
    ${optionalString (stdenv ? cross) ''
    sed -i -e 's/\(INSTALL.*\)-s/\1/' Makefile
    ''}
  '';

  buildFlags = [ "all" ];
  installFlags = [ "install.all" ];

  preInstall = ''
    makeFlagsArray+=(GLEW_DEST=$out BINDIR=$bin/bin INCDIR=$dev/include/GL)
  '';

  postInstall = ''
    mkdir -pv $out/share/doc/glew
    mkdir -p $out/lib/pkgconfig
    cp glew*.pc $out/lib/pkgconfig
    cp -r README.txt LICENSE.txt doc $out/share/doc/glew
    rm $out/lib/*.a
  '';

  crossAttrs.makeFlags = [
    "CC=${stdenv.cross.config}-gcc"
    "LD=${stdenv.cross.config}-gcc"
    "AR=${stdenv.cross.config}-ar"
    "STRIP="
  ] ++ optional (stdenv.cross.libc == "msvcrt") "SYSTEM=mingw"
    ++ optional (stdenv.cross.libc == "libSystem") "SYSTEM=darwin";

  meta = with stdenv.lib; {
    description = "An OpenGL extension loading library for C(++)";
    homepage = http://glew.sourceforge.net/;
    license = licenses.free; # different files under different licenses
      #["BSD" "GLX" "SGI-B" "GPL2"]
    platforms = platforms.mesaPlatforms;
  };
}
