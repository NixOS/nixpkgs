{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "onig-${version}";
  version = "6.9.1";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "0dbdd9r15fsqn0rimkjwlv8v68v4i1830h0m7dw56b335wwl6bbg";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kkos/oniguruma;
    description = "Regular expressions library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fuuzetsu ];
    platforms = platforms.unix;
  };
}
