{ stdenv
, lib
, fetchFromGitHub
, cmake
, gfortran
, blas
, lapack
, mctc-lib
, mstore
, toml-f
, multicharge
, dftd4
, simple-dftd3
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "tblite";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tblite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-R7CAFG/x55k5Ieslxeq+DWq1wPip4cI+Yvn1cBbeVNs=";
  };

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [
    blas
    lapack
    mctc-lib
    mstore
    toml-f
    multicharge
    dftd4
    simple-dftd3
  ];

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/${pname}.pc \
      --replace "''${prefix}" ""
  '';

  meta = with lib; {
    description = "Light-weight tight-binding framework";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    homepage = "https://github.com/tblite/tblite";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
