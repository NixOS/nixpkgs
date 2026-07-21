{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gtest,
  openssl,
  pe-parse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uthenticode";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "uthenticode";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NGVOGXMRlgpSRw56jr63rJc/5/qCmPjtAFa0D21ogd4=";
  };

  cmakeFlags = [
    "-DBUILD_TESTS=1"
    "-DUSE_EXTERNAL_GTEST=1"
  ];

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ gtest ];
  buildInputs = [
    pe-parse
    openssl
  ];

  doCheck = true;
  checkPhase = "test/uthenticode_test";

  meta = {
    description = "Small cross-platform library for verifying Authenticode digital signatures";
    homepage = "https://github.com/trailofbits/uthenticode";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ arturcygan ];
  };
})
