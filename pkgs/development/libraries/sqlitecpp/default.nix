{ lib, stdenv, fetchFromGitHub, cmake, sqlite, cppcheck, gtest }:

stdenv.mkDerivation rec {
  pname = "sqlitecpp";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = pname;
    rev = version;
    sha256 = "1c2yyipiqswi5sf9xmpsgw6l1illzmcpkjm56agk6kl2hay23lgr";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cppcheck ];
  buildInputs = [ sqlite gtest ];
  doCheck = true;

  cmakeFlags = [
    "-DSQLITECPP_INTERNAL_SQLITE=OFF"
    "-DSQLITECPP_BUILD_TESTS=ON"
  ];

  meta = with lib; {
    homepage = "https://srombauts.github.io/SQLiteCpp/";
    description = "C++ SQLite3 wrapper";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.jbedo maintainers.doronbehar ];
  };
}
