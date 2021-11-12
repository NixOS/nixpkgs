{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "libxc";
  version = "5.1.7";

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "0s01q5sh50544s7q2q7kahcqydlyzk1lx3kg1zwl76y90942bjd1";
  };

  nativeBuildInputs = [ perl cmake gfortran ];

  preConfigure = ''
    patchShebangs ./
  '';

  cmakeFlags = [ "-DENABLE_FORTRAN=ON" "-DBUILD_SHARED_LIBS=ON" ];

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)
  '';

  doCheck = true;

  meta = with lib; {
    description = "Library of exchange-correlation functionals for density-functional theory";
    homepage = "https://www.tddft.org/programs/Libxc/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markuskowa ];
  };
}
