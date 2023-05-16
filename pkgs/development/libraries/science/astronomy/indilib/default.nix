{ stdenv
, lib
, fetchFromGitHub
, cmake
, cfitsio
, libusb1
, zlib
, boost
, libev
, libnova
, curl
, libjpeg
, gsl
, fftw
<<<<<<< HEAD
, gtest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "indilib";
<<<<<<< HEAD
  version = "2.0.3";
=======
  version = "1.9.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YhUwRbpmEybezvopbqFj7M1EE3pufkNrN8yi/zbnJ3U=";
=======
    sha256 = "sha256-+KFuZgM/Bl6Oezq3WXjWCHefc1wvR3wOKXejmT0pw1U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    curl
    cfitsio
    libev
    libusb1
    zlib
    boost
    libnova
    libjpeg
    gsl
    fftw
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
<<<<<<< HEAD
  ] ++ lib.optional doCheck [
    "-DINDI_BUILD_UNITTESTS=ON"
    "-DINDI_BUILD_INTEGTESTS=ON"
  ];

  checkInputs = [ gtest ];

  doCheck = true;

  # Socket address collisions between tests
  enableParallelChecking = false;

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ hjones2199 sheepforce ];
    platforms = platforms.unix;
=======
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.unix;
    # error: use of undeclared identifier 'MSG_NOSIGNAL'
    broken = stdenv.isDarwin && stdenv.isx86_64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
