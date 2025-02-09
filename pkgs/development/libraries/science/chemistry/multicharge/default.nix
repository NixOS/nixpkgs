{ stdenv
, lib
, fetchFromGitHub
, cmake
, gfortran
, blas
, lapack
, mctc-lib
, mstore
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "multicharge";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oUI5x5/Gd0EZBb1w+0jlJUF9X51FnkHFu8H7KctqXl0=";
  };

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [ blas lapack mctc-lib mstore ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/${pname}.pc \
      --replace "''${prefix}/" ""
  '';

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Electronegativity equilibration model for atomic partial charges";
    license = licenses.asl20;
    homepage = "https://github.com/grimme-lab/multicharge";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
