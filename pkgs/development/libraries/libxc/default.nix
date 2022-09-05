{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "libxc";
  version = "5.2.3";

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "sha256-PuLpwhyyht+kkPUTrJTH+VTY5WuOhi2mIUDrFqubF+w=";
  };

  nativeBuildInputs = [ perl cmake gfortran ];

  preConfigure = ''
    patchShebangs ./
  '';

  cmakeFlags = [
    "-DENABLE_FORTRAN=ON"
    "-DBUILD_SHARED_LIBS=ON"
    # Force compilation of higher derivatives
    "-DDISABLE_VXC=0"
    "-DDISABLE_FXC=0"
    "-DDISABLE_KXC=0"
    "-DDISABLE_LXC=0"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library of exchange-correlation functionals for density-functional theory";
    homepage = "https://www.tddft.org/programs/Libxc/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
