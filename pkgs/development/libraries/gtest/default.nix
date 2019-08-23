{ stdenv, cmake, ninja, fetchFromGitHub
, static ? false }:

stdenv.mkDerivation rec {
  name = "gtest-${version}";
  version = "1.8.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-${version}";
    sha256 = "0270msj6n7mggh4xqqjp54kswbl7mkcc8px1p5dqdpmw5ngh9fzk";
  };

  patches = [
    ./fix-cmake-config-includedir.patch
  ];

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = stdenv.lib.optional (!static) "-DBUILD_SHARED_LIBS=ON";

  meta = with stdenv.lib; {
    description = "Google's framework for writing C++ tests";
    homepage = https://github.com/google/googletest;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zoomulator ivan-tkatchev ];
  };
}
