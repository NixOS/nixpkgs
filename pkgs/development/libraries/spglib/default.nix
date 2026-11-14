{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gfortran,
  gtest,
  openmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spglib";
  version = "2.8.0"; # N.B: if you change this, please update: pythonPackages.spglib

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lnD/tUY/fXxgOS/aB8tesTyLcqpOBzjZaMO2Kjznf1M=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
    gtest
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ openmp ];

  cmakeFlags = [ "-DSPGLIB_WITH_Fortran=On" ];

  doCheck = true;

  meta = {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.all;
  };
})
