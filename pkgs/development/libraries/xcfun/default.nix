{ stdenv
, fetchFromGitHub
, cmake
, gfortran
, perl
, bzip2
}:

stdenv.mkDerivation rec {
  pname = "xcfun";
  version = "1.0.X";

  src = fetchFromGitHub {
    owner = "dftlibs";
    repo = pname;
    rev = "355f42497a9cd17d16ae91da1f1aaaf93756ae8b"; # rev recommended by pythonPackages.pyscf: https://sunqm.github.io/pyscf/install.html#installation-without-network
    sha256 = "09hs8lxks2d98a5q2xky9dz5sfsrxaww3kyryksi9b6l1f1m3hxp";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    bzip2
    gfortran
    perl
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=1"
    "-DBUILD_SHARED_LIBS=1"
    "-DXC_MAX_ORDER=3"
  ];

  # TODO: tests are very quick. check it actually does something.
  doCheck = true;
  checkPhase = ''
    # set path for finding libxc.so for tests
    export LD_LIBRARY_PATH=/build/source/build
    ctest --progress
  '';

  meta = with stdenv.lib; {
    description = "Exchange-correlation functionals with arbitrary order derivatives";
    homepage = "https://xcfun.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/dftlibs/xcfun/releases";
    license = licenses.mpl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
