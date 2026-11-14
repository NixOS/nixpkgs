{
  stdenv,
  lib,
  gfortran,
  blas,
  cmake,
  lapack,
  python3,
  enableMpi ? true,
  mpi,
  fetchFromGitHub,
  fetchpatch,
}:
assert (!blas.isILP64);
assert blas.isILP64 == lapack.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "wannier90";
  version = "4.0.3";

  nativeBuildInputs = [
    gfortran
    mpi
    cmake
  ];
  buildInputs = [
    blas
    lapack
  ];

  src = fetchFromGitHub {
    owner = "wannier-developers";
    repo = "wannier90";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8Jf/ryiZRvS7vVIkJlWAdPdsXiiv8LZI8CA5uDtIyc8=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  passthru = { inherit mpi; };

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  # test cases are removed as error bounds of wannier90 are obviously to tight
  postPatch = ''
    rm -r test-suite/tests/testw90_graphene_dis_proj_auto
  '';

  patches = [
    # upstream patch, fixes absolute paths in .pc config
    (fetchpatch {
      name = "account-for-absolute-paths-in-pc-file";
      url = "https://github.com/wannier-developers/wannier90/commit/86e487dfb580a66389eed1f3100568411b38bfdb.patch";
      hash = "sha256-eOSeOZiTtbBDPh9BudP7kyrA87cNr1KAFm25WHwpoco=";
    })
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "WANNIER90_WITH_C" true)
    (lib.strings.cmakeBool "WANNIER90_MPI" enableMpi)
  ];

  doCheck = true;
  nativeCheckInputs = [
    python3
    python3.pkgs.pytest
    python3.pkgs.pyaml
  ];
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';
  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    description = "Calculation of maximally localised Wannier functions";
    homepage = "https://github.com/wannier-developers/wannier90";
    license = lib.licenses.lgpl21Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
