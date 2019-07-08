{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "onig-${version}";
  version = "6.9.2";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "15asc9v6ylal8fwzlnrh673mp62wngxvv9jx7h86vhljjdap6yfc";
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
