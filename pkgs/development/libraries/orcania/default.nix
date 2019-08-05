{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kq1cpayflh4xy442q6prrkalm8lcz2cxydrp1fv8ppq1cnq4zr7";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    homepage = "https://github.com/babelouest/orcania";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
