{
  stdenv,
  lib,
  gfortran,
  perl,
  blas,
  lapack,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:
assert (!blas.isILP64);
assert blas.isILP64 == lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "wannier90";
  version = "3.1.0";

  nativeBuildInputs = [
    gfortran
    perl
  ];
  buildInputs = [
    blas
    lapack
  ];

  src = fetchFromGitHub {
    owner = "wannier-developers";
    repo = "wannier90";
    rev = "v${version}";
    hash = "sha256-+Mq7lM6WuwAnK/2FlDz9gNRIg2sRazQRezb3BfD0veY=";
  };

  patches = [
    # upstream patch, fixes test runner.
    (fetchpatch {
      name = "replace-obsolete-pipes-module";
      url = "https://github.com/wannier-developers/wannier90/commit/8aef6edaa4f169d45b479dc5d5c5efb8b9385a49.patch";
      hash = "sha256-6ZfHd8CVTzfaj99AA3dsJJ/EOeCZmzACAM5pe2wBo8g=";
    })
  ];

  # Increase all numerical thresholds by a factor of 5. The tests are not
  # numerically stable enough with differen BLAS and LAPACK implementations and
  # dynamic CPU detection.
  postPatch = ''
    perl -i.bak -pe 's/(\d+\.\d+e[+-]?\d+)/sprintf("%.10e", $1 * 5)/ge' test-suite/tests/userconfig
    rm -r test-suite/tests/testw90_example26   # Fails without AVX optimizations
    patchShebangs test-suite/run_tests test-suite/testcode/bin/testcode.py
  '';

  configurePhase = ''
    runHook preConfigure

    cp config/make.inc.gfort make.inc

    runHook postConfigure
  '';

  buildFlags = [
    "all"
    "dynlib"
  ];

  preInstall = ''
    installFlagsArray+=(
      PREFIX=$out
    )
  '';

  postInstall = ''
    cp libwannier.so $out/lib/libwannier.so

    mkdir $out/include
    find ./src/obj/ -name "*.mod" -exec cp {} $out/include/. \;
  '';

  doCheck = true;
  checkInputs = [ python3 ];
  checkTarget = [ "test-serial" ];
  preCheck = ''
    export OMP_NUM_THREADS=4
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    description = "Calculation of maximally localised Wannier functions";
    homepage = "https://github.com/wannier-developers/wannier90";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
