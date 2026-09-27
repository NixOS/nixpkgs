{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbyak";
  version = "7.42";

  src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GwsHEjqUBExb4pIZ6Z6YWGka0Fx3Qby4YYG0Otm6OAw=";
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
