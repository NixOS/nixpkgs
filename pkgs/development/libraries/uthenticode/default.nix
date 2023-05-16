{ stdenv, lib, fetchFromGitHub, cmake, gtest, openssl, pe-parse }:

stdenv.mkDerivation rec {
  pname = "uthenticode";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.0.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "uthenticode";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XGKROp+1AJWUjCwMOikh+yvNMGuENJGb/kzJsEOEFeY=";
=======
    hash = "sha256-MEpbvt03L501BP42j6S7rXE9j1d8j6D2Y5kgPNlbHzc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cmakeFlags = [ "-DBUILD_TESTS=1" "-DUSE_EXTERNAL_GTEST=1" ];

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ gtest ];
  buildInputs = [ pe-parse openssl ];

  doCheck = true;
  checkPhase = "test/uthenticode_test";

  meta = with lib; {
    description = "A small cross-platform library for verifying Authenticode digital signatures.";
    homepage = "https://github.com/trailofbits/uthenticode";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}
