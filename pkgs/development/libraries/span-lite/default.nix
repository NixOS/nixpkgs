{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "span-lite";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "span-lite";
    rev = "v${version}";
    hash = "sha256-WfoyyPLBqXSGGATWN/wny6P++3aCmQMOMLCARhB+R3c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "A C++20-like span for C++98, C++11 and later in a single-file header-only library";
    homepage = "https://github.com/martinmoene/span-lite";
    license = lib.licenses.bsd1;
    maintainers = with lib.maintainers; [ icewind1991 ];
    platforms = lib.platforms.all;
  };
}
