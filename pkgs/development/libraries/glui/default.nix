{stdenv, fetchurl, freeglut, mesa, libXmu, libXext, libX11, libXi}:
stdenv.mkDerivation {
  name = "glui-2.35";
  buildInputs = [freeglut mesa libXmu libXext libX11 libXi];
  preConfigure = ''cd src'';
  installPhase = ''
    mkdir -p "$out"/{bin,lib,share/glui/doc,include}
    cp -rT bin "$out/bin"
    cp -rT lib "$out/lib"
    cp -rT include "$out/include"
    cp -rT doc "$out/share/glui/doc"
    cp LICENSE.txt "$out/share/glui/doc"
  '';
  src = fetchurl {
    url = "mirror://sourceforge/project/glui/Source/2.36/glui-2.36.tgz";
    sha256 = "11r7f0k5jlbl825ibhm5c6bck0fn1hbliya9x1f253ikry1mxvy1";
  };
  meta = {
    description = ''A user interface library using OpenGL'';
    license = stdenv.lib.licenses.zlib ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
