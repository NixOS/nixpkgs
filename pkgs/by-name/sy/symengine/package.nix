{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gmp,
  flint,
  mpfr,
  libmpc,
  libllvm,
  withShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "symengine";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+CTOqD2RITDk1Q3g/00kqcjmoGyCiL4ue7wAtf8Ud2w=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gmp
    flint
    mpfr
    libmpc
    libllvm
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_FLINT" true)
    (lib.cmakeFeature "INTEGER_CLASS" "flint")
    (lib.cmakeBool "WITH_SYMENGINE_THREAD_SAFE" true)
    (lib.cmakeBool "WITH_MPC" true)
    (lib.cmakeBool "WITH_LLVM" true)
    (lib.cmakeBool "BUILD_FOR_DISTRIBUTION" true)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_SHARED_LIBS" withShared)
  ];

  doCheck = true;

  meta = {
    description = "Fast symbolic manipulation library";
    homepage = "https://github.com/symengine/symengine";
    platforms = with lib.platforms; unix ++ windows;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
})
