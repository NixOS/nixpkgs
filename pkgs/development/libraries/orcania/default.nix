{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "11ihbfm7qbqf55wdi7azqx75ggd3l0n8ybyq2ikidffvmg13l4g9";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    homepage = "https://github.com/babelouest/orcania";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
