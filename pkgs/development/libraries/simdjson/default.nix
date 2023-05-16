{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "simdjson";
<<<<<<< HEAD
  version = "3.2.3";
=======
  version = "3.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-h15IyPYvIUPDOJ03KgEDyRhXe0Oi8XCR5LnzSpPc4PI=";
=======
    sha256 = "sha256-a6I1qcuBSkwQxuU4T7tKrqouhLMJsY/rfCKqhGGvkjQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSIMDJSON_DEVELOPER_MODE=OFF"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "-DBUILD_SHARED_LIBS=OFF"
  ] ++ lib.optionals (with stdenv.hostPlatform; isPower && isBigEndian) [
    # Assume required CPU features are available, since otherwise we
    # just get a failed build.
    "-DCMAKE_CXX_FLAGS=-mpower8-vector"
  ];

  meta = with lib; {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ chessai ];
  };
}
