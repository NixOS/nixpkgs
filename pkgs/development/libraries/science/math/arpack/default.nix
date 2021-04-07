{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
, gfortran, blas, lapack, eigen }:

stdenv.mkDerivation rec {
  pname = "arpack";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "opencollab";
    repo = "arpack-ng";
    rev = version;
    sha256 = "sha256-nc710iLRqy/p3EaVgbEoCRzNJ9GpKqqQp33tbn7R6lA=";
  };

  patches = [
    # https://github.com/opencollab/arpack-ng/pull/301
    (fetchpatch {
      name = "pkg-config-paths.patch";
      url = "https://github.com/opencollab/arpack-ng/commit/47fc83cb371a9cc8a8c058097de5e0298cd548f5.patch";
      excludes = [ "CHANGES" ];
      sha256 = "1aijvrfsxkgzqmkzq2dmaj8q3jdpg2hwlqpfl8ddk9scv17gh9m8";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = assert (blas.isILP64 == lapack.isILP64); [
    gfortran
    blas
    lapack
    eigen
  ];

  doCheck = true;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DINTERFACE64=${if blas.isILP64 then "1" else "0"}"
  ];

  preCheck = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}`pwd`/lib:${blas}/lib:${lapack}/lib
  '' else ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}`pwd`/lib
  '' + ''
    # Prevent tests from using all cores
    export OMP_NUM_THREADS=2
  '';

  meta = {
    homepage = "https://github.com/opencollab/arpack-ng";
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ttuegel dotlambda ];
    platforms = lib.platforms.unix;
  };
}
