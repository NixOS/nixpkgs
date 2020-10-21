{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
# The two audio backends:
, SDL2
, jack2
}:

stdenv.mkDerivation rec {
  pname = "audiality2";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "olofson";
    repo = "audiality2";
    rev = "v${version}";
    sha256 = "0ipqna7a9mxqm0fl9ggwhbc7i9yxz3jfyi0w3dymjp40v7jw1n20";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    jack2
  ];

  meta = with stdenv.lib; {
    description = "A realtime scripted modular audio engine for video games and musical applications";
    homepage = "http://audiality.org";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}

