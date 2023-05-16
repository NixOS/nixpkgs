{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "double-conversion";
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-DkMoHHoHwV4p40IINEqEPzKsCa0LHrJAFw2Yftw7zHo=";
=======
    sha256 = "sha256-vrh/dCuleE3fikryXX86XC/fdVV+j8HvIe4s/SRpNJw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # Case sensitivity issue
  preConfigure = lib.optionalString stdenv.isDarwin ''
    rm BUILD
  '';

  meta = with lib; {
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = "https://github.com/google/double-conversion";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
