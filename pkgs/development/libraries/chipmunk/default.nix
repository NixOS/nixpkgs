{ stdenv, fetchurl, cmake, freeglut, mesa, glfw2, glew, libX11, xproto
, inputproto, libXi, libXmu
}:

stdenv.mkDerivation rec {
  name = "chipmunk-${version}";
  majorVersion = "7";
  version = "${majorVersion}.0.0";

  src = fetchurl {
    url = "https://chipmunk-physics.net/release/Chipmunk-${majorVersion}.x/Chipmunk-${version}.tgz";
    sha256 = "1kaii8wgvp0kgn2p22jm9smyqlws4p5dg8j23jaiasx9jq1kiaql";
  };

  buildInputs =
    [ cmake freeglut mesa glfw2 glew libX11 xproto inputproto libXi libXmu ];

  postInstall = ''
    mkdir -p $out/bin
    cp demo/chipmunk_demos $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A fast and lightweight 2D game physics library";
    homepage = http://chipmunk2d.net/;
    license = licenses.mit;
    platforms = platforms.unix; # supports Windows and MacOS as well, but those require more work
  };
}
