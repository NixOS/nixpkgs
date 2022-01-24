{ lib, stdenv, fetchFromGitHub, cmake, perl, gfortran, python2
, boost, eigen, zlib
} :

stdenv.mkDerivation rec {
  pname = "pcmsolver";
  version = "1.3.0";

  src = fetchFromGitHub  {
    owner = "PCMSolver";
    repo = pname;
    rev = "v${version}";
    sha256= "0jrxr8z21hjy7ik999hna9rdqy221kbkl3qkb06xw7g80rc9x9yr";
  };

  nativeBuildInputs = [
    cmake
    gfortran
    perl
    python2
  ];

  buildInputs = [
    boost
    eigen
    zlib
  ];

  cmakeFlags = [ "-DENABLE_OPENMP=ON" ];

  hardeningDisable = [ "format" ];

  # Requires files, that are not installed.
  doCheck = false;

  meta = with lib; {
    description = "An API for the Polarizable Continuum Model";
    homepage = "https://pcmsolver.readthedocs.io/en/stable/";
    license = licenses.lgpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
