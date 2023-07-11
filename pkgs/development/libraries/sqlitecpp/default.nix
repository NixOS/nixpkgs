{ lib, stdenv, fetchFromGitHub, cmake, sqlite, gtest }:

stdenv.mkDerivation rec {
  pname = "sqlitecpp";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = pname;
    rev = version;
    sha256 = "sha256-3Xo/FgifbrSn0AvinriJZerUM2kbcMaoyF5ST8+1Qqw=";
  };

  nativeBuildInputs = [ cmake ];
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
