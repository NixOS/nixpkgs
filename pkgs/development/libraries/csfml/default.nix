{ stdenv, fetchFromGitHub, cmake, sfml }:

let
  version = "2.5";
in

stdenv.mkDerivation {
  pname = "csfml";
  inherit version;
  src = fetchFromGitHub {
    owner = "SFML";
    repo  = "CSFML";
    rev   = version;
    sha256 = "071magxif5nrdddzk2z34czqmz1dfws4d7dqynb2zpn7cwhwxcpm";
  };
  buildInputs = [ cmake sfml ];
  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/" ];

  meta = with stdenv.lib; {
    homepage = https://www.sfml-dev.org/;
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
