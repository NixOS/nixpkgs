{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, openssl
}:

stdenv.mkDerivation rec {
  pname = "cxxtools";
  version = "unstable-2021-12-23";

  src = fetchFromGitHub {
    owner = "maekitalo";
    repo = "cxxtools";
    rev = "31a212fe400b36cc5b9ea0dd76d9b5facfde914d";
    hash = "sha256-h7/G5aPnEsGjOL2NrKAnw4VfWTr8o4u574albdqFdjg=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl.dev ];

  configureFlags = lib.optional stdenv.isAarch64 "--with-atomictype=pthread";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/maekitalo/cxxtools";
    description = "Comprehensive C++ class library for Unix and Linux";
    platforms = platforms.linux;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ juliendehos ];
  };
}
