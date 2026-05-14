{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  outputs = [
    "out"
    "dev"
  ];

  # upgrade supported cmake version in SymEngineConfig.cmake
  patches = [
    (fetchpatch2 {
      url = "https://github.com/symengine/symengine/commit/c149b874b8ff947e51e8e58670a0d37daf588f86.patch?full_index=1";
      hash = "sha256-LqkJRPdsbE8OE8G6AkpWX9B+GqnOQjUNPHpKKIcCL3Q=";
    })
    (fetchpatch2 {
      url = "https://github.com/symengine/symengine/commit/186f72e208220efd12362c336a49378076f63f30.patch?full_index=1";
      hash = "sha256-CuQra9K3MTxm8M0bt3LooJz9HgW0/Jy6ydRBCvEgkO4=";
    })
  ];

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
