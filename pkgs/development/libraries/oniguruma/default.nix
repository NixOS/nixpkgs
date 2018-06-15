{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "onig-${version}";
  version = "6.8.2";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "00ly5i26n7wajhyhq3xadsc7dxrf7qllhwilk8dza2qj5dhld4nd";
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
