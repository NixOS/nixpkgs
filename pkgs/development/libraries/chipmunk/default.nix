{ stdenv, fetchurl, cmake, freeglut, libGLU, libGL, glfw2, glew, libX11, xorgproto
, libXi, libXmu
}:

stdenv.mkDerivation rec {
  pname = "chipmunk";
  majorVersion = "7";
  version = "${majorVersion}.0.1";

  src = fetchurl {
    url = "https://chipmunk-physics.net/release/Chipmunk-${majorVersion}.x/Chipmunk-${version}.tgz";
    sha256 = "0q4jwv1icz8spcjkp0v3bnygi6hq2zmnsgcxkwm8i2bxfxjb8m7y";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ freeglut libGLU libGL glfw2 glew libX11 xorgproto libXi libXmu ];

  postInstall = ''
    mkdir -p $out/bin
    cp demo/chipmunk_demos $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A fast and lightweight 2D game physics library";
    homepage = "http://chipmunk2d.net/";
    license = licenses.mit;
    platforms = platforms.unix; # supports Windows and MacOS as well, but those require more work
  };
}
