{ stdenv, fetchFromGitHub, cmake
, gfortran, blas, lapack, eigen }:

with stdenv.lib;

let
  version = "3.7.0";
in
stdenv.mkDerivation {
  pname = "arpack";
  inherit version;

  src = fetchFromGitHub {
    owner = "opencollab";
    repo = "arpack-ng";
    rev = version;
    sha256 = "1x7a1dj3dg43nlpvjlh8jzzbadjyr3mbias6f0256qkmgdyk4izr";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gfortran blas lapack eigen ];

  doCheck = true;

  BLAS_LIBS = "-L${blas}/lib -lblas";
  LAPACK_LIBS = "-L${lapack}/lib -llapack";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DINTERFACE64=${optionalString blas.isILP64 "1"}"
  ];

  preCheck = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}`pwd`/lib
  '' else ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}`pwd`/lib
  '' + ''
    # Prevent tests from using all cores
    export OMP_NUM_THREADS=2
  '';

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cp arpack.pc $out/lib/pkgconfig/
  '';


  meta = {
    homepage = "https://github.com/opencollab/arpack-ng";
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.unix;
  };
}
