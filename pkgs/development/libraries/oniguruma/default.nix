{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "onig";
  version = "6.9.3";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "0wzmqpjmxpryk83acbyhl9gwgm43ixbwraga2g5li9kx88mv4k0n";
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
