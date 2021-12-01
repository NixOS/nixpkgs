{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, gtest, openssl, pe-parse }:

stdenv.mkDerivation rec {
  pname = "uthenticode";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "uthenticode";
    rev = "v${version}";
    sha256 = "16j91cki63zk4d7wzwvq8al98l8hmvcdil3vfp44ink4q4bfswkx";
  };

  patches = [
    # adds USE_SYSTEM_GTEST cmake flag, the patch won't be necessary in next versions
    (fetchpatch {
      url = "https://github.com/trailofbits/uthenticode/commit/7a4c5499c8e5ea7bfae1c620e1f96c112866b1dd.patch";
      sha256 = "17637j5zwp71jmi803mv1z04arld3k3kmrm8nvrkpg08q5kizh28";
    })
  ];

  cmakeFlags = [ "-DBUILD_TESTS=1" "-DUSE_SYSTEM_GTEST=1" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ pe-parse openssl gtest ];

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
