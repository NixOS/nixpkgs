{ lib, stdenv, fetchFromGitHub, cmake, sqlite, gtest }:

stdenv.mkDerivation rec {
  pname = "sqlitecpp";
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-3Xo/FgifbrSn0AvinriJZerUM2kbcMaoyF5ST8+1Qqw=";
=======
    sha256 = "sha256-uVvlW95UD1dhJfNuKgo7XvbdXrHl95OhaEpWfn0RH/E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
