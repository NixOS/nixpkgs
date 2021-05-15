{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

let
  version = "5.1.4";

in stdenv.mkDerivation {
  pname = "libxc";
  inherit version;

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "0rs6v72zz3jr22r29zxxdk8wdsfv6wid6cx2661974z09dbvbr1f";
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
