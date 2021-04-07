{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

let
  version = "5.1.2";

in stdenv.mkDerivation {
  pname = "libxc";
  inherit version;

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "1bcj7x0kaal62m41v9hxb4h1d2cxs2ynvsfqqg7c5yi7829nvapb";
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
