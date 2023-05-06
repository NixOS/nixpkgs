{ stdenv
, lib
, fetchFromGitHub
, gfortran
, cmake
, mctc-lib
, mstore
, toml-f
, blas
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "simple-dftd3";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5OvmMgjD8ujjKHkuw4NT8hEXKh5YPxuBl/Mu6g2/KIA=";
  };

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [ mctc-lib mstore toml-f blas ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/s-dftd3.pc \
      --replace "''${prefix}/" ""
  '';

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Reimplementation of the DFT-D3 program";
    license = with licenses; [ lgpl3Only gpl3Only ];
    homepage = "https://github.com/dftd3/simple-dftd3";
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
  };
}
