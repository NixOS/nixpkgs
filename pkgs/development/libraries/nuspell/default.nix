{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, icu, catch2 }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "sha256-nGC8Um9GutJZXlUcUCK0IiHxMaZmeoe4febw/jC2dRU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  propagatedBuildInputs = [ icu ];

  outputs = [ "out" "lib" "dev" ];

  postPatch = ''
    rm -rf external/Catch2
    ln -sf ${catch2.src} external/Catch2
  '';

  meta = with lib; {
    description = "Free and open source C++ spell checking library";
    homepage = "https://nuspell.github.io/";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.lgpl3Plus;
    changelog = "https://github.com/nuspell/nuspell/blob/v${version}/CHANGELOG.md";
  };
}
