{ lib, stdenv, fetchFromGitHub, cmake, sfml }:

stdenv.mkDerivation rec {
  pname = "csfml";
<<<<<<< HEAD
  version = "2.5.2";
=======
  version = "2.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "SFML";
    repo  = "CSFML";
    rev   = version;
<<<<<<< HEAD
    sha256 = "sha256-A5C/4SnxUX7mW1wkPWJWX3dwMhrJ79DkBuZ7UYzTOqE=";
=======
    sha256 = "sha256-a46V5CakKVygNfr3/nZwlsCyqNsbti4a3cr7itK5QfI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];
  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/" ];

  meta = with lib; {
    homepage = "https://www.sfml-dev.org/";
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
