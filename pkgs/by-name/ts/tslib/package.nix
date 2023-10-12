{ lib, fetchFromGitHub, stdenv, cmake }:

stdenv.mkDerivation rec {

  pname = "tslib";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "libts";
    repo = "tslib";
    rev = version;
    hash = "sha256-fiEC8WakW1ApNSTqaGVQXmbiVd3rqSF2dpunUfw296Q=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "http://www.tslib.org";
    description = "C library for filtering touchscreen events";
    license = lib.licenses.lgpl21;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ liarokapisv ];
  };
}
