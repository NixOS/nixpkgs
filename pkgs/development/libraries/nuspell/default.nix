{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, boost, icu, catch2 }:

stdenv.mkDerivation rec {
  name = "nuspell-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "0gcw3p1agnx474r7kv27y9jyab20p4j4xx7j9a2yssg54qabm71j";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ boost icu ];

  enableParallelBuilding = true;

  preBuild = ''
    ln -s ${catch2}/include/catch2/*.hpp tests/
  '';

  meta = with stdenv.lib; {
    description = "Free and open source C++ spell checking library";
    homepage = "https://nuspell.github.io/";
    maintainers = with maintainers; [ fpletz ];
  };
}
