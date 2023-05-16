{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "libxc";
<<<<<<< HEAD
  version = "6.2.2";
=======
  version = "6.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-JYhuyW95I7Q0edLIe7H//+ej5vh6MdAGxXjmNxDMuhQ=";
  };

  # Timeout increase has already been included upstream in master.
  # Check upon updates if this can be removed.
  postPatch = ''
    substituteInPlace testsuite/CMakeLists.txt \
        --replace "PROPERTIES TIMEOUT 1" "PROPERTIES TIMEOUT 30"
  '';

=======
    hash = "sha256-PqKqZbL9Y7lKu7tKo+DfAhoEeFSsYWEcwiFX41VhRIs=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ perl cmake gfortran ];

  preConfigure = ''
    patchShebangs ./
  '';

  cmakeFlags = [
    "-DENABLE_FORTRAN=ON"
    "-DBUILD_SHARED_LIBS=ON"
<<<<<<< HEAD
    "-DENABLE_XHOST=OFF"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
