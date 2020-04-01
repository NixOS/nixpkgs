with import <nixpkgs> { };

stdenv.mkDerivation {
  pname = "raylib";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/raysan5/raylib/archive/2.6.0.tar.gz";
    sha256 = "494e95eaf8daf3f086116dfd6a5fd2e9a2166fc744eabf4f3067bf887d4fb5ef";
  };

  buildInputs = [
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xlibs.libXi
    xlibs.libXext
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com";
    license = stdenv.lib.licenses.zlib;
    maintainers = [ stdenv.lib.mantainers.svantepolk ];
  };
}
