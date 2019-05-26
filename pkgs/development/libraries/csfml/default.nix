{ stdenv, fetchFromGitHub, cmake, sfml }:

let
  version = "2.4";
in

stdenv.mkDerivation {
  name = "csfml-${version}";
  src = fetchFromGitHub {
    owner = "SFML";
    repo  = "CSFML";
    rev   = "b5facb85d13bff451a5fd2d088a97472a685576c";
    sha256 = "1q716gd7c7jlxzwpq5z4rjj5lsrn71ql2djphccdf9jannllqizn";
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
