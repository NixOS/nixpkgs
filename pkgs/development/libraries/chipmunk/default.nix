{ lib, stdenv, fetchurl, cmake, freeglut, libGLU, libGL, glfw2, glew, libX11, xorgproto
, libXi, libXmu, fetchpatch, libXrandr
}:

stdenv.mkDerivation rec {
  pname = "chipmunk";
  majorVersion = "7";
  version = "${majorVersion}.0.3";

  src = fetchurl {
    url = "https://chipmunk-physics.net/release/Chipmunk-${majorVersion}.x/Chipmunk-${version}.tgz";
    sha256 = "06j9cfxsyrrnyvl7hsf55ac5mgff939mmijliampphlizyg0r2q4";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/slembcke/Chipmunk2D/commit/9a051e6fb970c7afe09ce2d564c163b81df050a8.patch";
      sha256 = "0ps8bjba1k544vcdx5w0qk7gcjq94yfigxf67j50s63yf70k2n70";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ freeglut libGLU libGL glfw2 glew libX11 xorgproto libXi libXmu libXrandr ];

  postInstall = ''
    mkdir -p $out/bin
    cp demo/chipmunk_demos $out/bin
  '';

  meta = with lib; {
    description = "A fast and lightweight 2D game physics library";
    mainProgram = "chipmunk_demos";
    homepage = "http://chipmunk2d.net/";
    license = licenses.mit;
    platforms = platforms.unix; # supports Windows and MacOS as well, but those require more work
  };
}
