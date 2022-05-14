{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, cxxtools
, openssl
, zip
, zlib
}:

stdenv.mkDerivation {
  pname = "tntnet";
  version = "unstable-2021-03-29";

  src = fetchFromGitHub {
    owner = "maekitalo";
    repo = "tntnet";
    rev = "725bc4dffea94525e6722c625bb6720e4bb470a0";
    hash = "sha256-GaCodhg7GKK2qKolQJ+RxlhUuAKOYcrtrNjvFx9k+KA=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ cxxtools openssl zip zlib ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/maekitalo/tntnet";
    description = "Web server which allows users to develop web applications using C++";
    platforms = platforms.linux ;
    license = licenses.lgpl21;
    maintainers = [ maintainers.juliendehos ];
  };
}
