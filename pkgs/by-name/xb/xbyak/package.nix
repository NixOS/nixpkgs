{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbyak";
  version = "7.40";

  src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4AELojCkOK0O9Rs9DwR4otZOcEFnNKRG4VAJFoX5Bds=";
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
