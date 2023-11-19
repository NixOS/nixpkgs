{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, icu, catch2 }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    hash = "sha256-ww7Kqzlnf7065i9RZLeFDUOPBMCVgV/6sBnN0+WvBTk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ catch2 ];
  propagatedBuildInputs = [ icu ];

  cmakeFlags = [ "-DBUILD_TESTING=YES" ];
  doCheck = true;

  outputs = [ "out" "lib" "dev" ];

  meta = with lib; {
    description = "Free and open source C++ spell checking library";
    homepage = "https://nuspell.github.io/";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.lgpl3Plus;
    changelog = "https://github.com/nuspell/nuspell/blob/v${version}/CHANGELOG.md";
  };
}
