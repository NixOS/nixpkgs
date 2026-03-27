{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbyak";
  version = "7.35.3";

  src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qsv0cgm5AmH9Ip1cNX8fKEA5D2b/255ZhYtCQb9Kr5I=";
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
