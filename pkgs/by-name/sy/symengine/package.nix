{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gmp,
  flint,
  mpfr,
  libmpc,
  withShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "symengine";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WriVcYt3fkObR2U4J6a4KGGc2HgyyFyFpdrwxBD+AHA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gmp
    flint
    mpfr
    libmpc
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_FLINT" true)
    (lib.cmakeFeature "INTEGER_CLASS" "flint")
    (lib.cmakeBool "WITH_SYMENGINE_THREAD_SAFE" true)
    (lib.cmakeBool "WITH_MPC" true)
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
