{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbyak";
  version = "7.34.1";

  src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cajYwHw9/RzPAQw3c0zpNRm/nBBym0OtowqqtYnpVWc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "JIT assembler for x86/x64 architectures supporting advanced instruction sets up to AVX10.2";
    homepage = "https://github.com/herumi/xbyak";
    changelog = "https://github.com/herumi/xbyak/blob/v${finalAttrs.version}/doc/changelog.md";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
