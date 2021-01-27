{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

let
  version = "5.1.0";

in stdenv.mkDerivation {
  pname = "libxc";
  inherit version;

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "0qbxh0lfx4cab1fk1qfnx72g4yvs376zqrq74jn224vy32nam2x7";
  };

  buildInputs = [ gfortran ];
  nativeBuildInputs = [ perl cmake ];

  preConfigure = ''
    patchShebangs ./
  '';

  cmakeFlags = [ "-DENABLE_FORTRAN=ON" "-DBUILD_SHARED_LIBS=ON" ];

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library of exchange-correlation functionals for density-functional theory";
    homepage = "https://www.tddft.org/programs/Libxc/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markuskowa ];
  };
}
