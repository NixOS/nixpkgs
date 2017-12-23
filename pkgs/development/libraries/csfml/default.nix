{ stdenv, fetchurl, cmake, sfml }:

let
  version = "2.4";
in

stdenv.mkDerivation {
  name = "csfml-${version}";
  src = fetchurl {
    url = "https://github.com/SFML/CSFML/archive/b5facb85d13bff451a5fd2d088a97472a685576c.tar.gz";
    sha256 = "22c1fc871b278d96eec3d7d4fa1d49fb06d401689cabe678d51dc5b6be3b9205";
  };
  buildInputs = [ cmake sfml ];
  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/" ];
  meta = with stdenv.lib; {
    homepage = http://www.sfml-dev.org/;
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.jpdoyle ];
    platforms = platforms.linux;
  };
}
