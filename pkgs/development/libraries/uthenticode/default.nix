{ stdenv, lib, fetchFromGitHub, cmake, gtest, openssl, pe-parse }:

stdenv.mkDerivation rec {
  pname = "uthenticode";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "uthenticode";
    rev = "v${version}";
    hash = "sha256-H4fAHZM+vYaUkXZE4f7r2bxw9dno7O+lYrqQ9/6YPWA=";
  };

  cmakeFlags = [ "-DBUILD_TESTS=1" "-DUSE_EXTERNAL_GTEST=1" ];

  nativeBuildInputs = [ cmake ];
  checkInputs = [ gtest ];
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
