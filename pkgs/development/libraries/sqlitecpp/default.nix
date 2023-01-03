{ lib, stdenv, fetchFromGitHub, cmake, sqlite, cppcheck, gtest }:

stdenv.mkDerivation rec {
  pname = "sqlitecpp";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z1c2lQZ0UltcIf9dTnumZPhke4uEmsjg/Ygppvx3kxY=";
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
