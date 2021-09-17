{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "libxc";
  version = "5.1.6";

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "07iljmv737kx24kd33x9ndf5l854mwslg9x2psqm12k07jmq9wjw";
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
