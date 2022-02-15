{ lib, stdenv, fetchFromGitHub, cmake, primesieve }:

stdenv.mkDerivation rec {
  pname = "primecount";
  version = "7.2";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ primesieve ];

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primecount";
    rev = "v${version}";
    sha256 = "sha256-/Cb/HkD4UQ9gXsRpvRiEuQBoRd0THxNHsBaAAa+CqQo=";
  };

  cmakeFlags = [
    "-DBUILD_STATIC_LIBS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_TESTS=ON"
    "-DBUILD_PRIMECOUNT=ON"
    "-DBUILD_LIBPRIMESIEVE=ON"
  ];

  meta = with lib; {
    description = "Fast prime counting function implementations";
    homepage = "https://github.com/kimwalisch/primecount";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = teams.sage.members;
  };
}
