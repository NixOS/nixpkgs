{ stdenv, fetchFromGitHub, cmake, libav, SDL2, chromaprint, libebur128 }:

stdenv.mkDerivation rec {
  version = "4.3.0";
  name = "libgroove-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libgroove";
    rev = "${version}";
    sha256 = "1la9d9kig50mc74bxvhx6hzqv0nrci9aqdm4k2j4q0s1nlfgxipd";
  };

  buildInputs = [ cmake libav SDL2 chromaprint libebur128 ];

  meta = with stdenv.lib; {
    description = "Streaming audio processing library";
    homepage = https://github.com/andrewrk/libgroove;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
