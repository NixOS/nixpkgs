{ stdenv, lib, fetchFromGitHub, cmake, gtest, openssl, pe-parse }:

stdenv.mkDerivation rec {
  pname = "uthenticode";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "uthenticode";
    rev = "v${version}";
    hash = "sha256-XGKROp+1AJWUjCwMOikh+yvNMGuENJGb/kzJsEOEFeY=";
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
