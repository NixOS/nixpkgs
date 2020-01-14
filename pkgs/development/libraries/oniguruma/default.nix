{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "onig";
  version = "6.9.4";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "11imbhj4p5w8lvrmcczccm1zq014h9j85r51z2ibb8jhf5p3lslh";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kkos/oniguruma;
    description = "Regular expressions library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
