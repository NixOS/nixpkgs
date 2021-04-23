{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

let
  version = "5.1.3";

in stdenv.mkDerivation {
  pname = "libxc";
  inherit version;

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "14czspifznsmvvix5hcm1rk18iy590qk8p5m00p0y032gmn9i2zj";
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

  meta = with lib; {
    description = "Library of exchange-correlation functionals for density-functional theory";
    homepage = "https://www.tddft.org/programs/Libxc/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markuskowa ];
  };
}
