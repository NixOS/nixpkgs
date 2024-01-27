{ stdenv
, lib
, fetchFromGitHub
, bash
, cmake
, cfitsio
, libusb1
, kmod
, zlib
, boost
, libev
, libnova
, curl
, libjpeg
, gsl
, fftw
, gtest
}:

stdenv.mkDerivation rec {
  pname = "indilib";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${version}";
    hash = "sha256-n1zj1U26l30JYr5Tio5zwv8v/e2cjEeIRGsyncMtt9I=";
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
  ] ++ lib.optional doCheck [
    "-DINDI_BUILD_UNITTESTS=ON"
    "-DINDI_BUILD_INTEGTESTS=ON"
  ];

  checkInputs = [ gtest ];

  doCheck = true;

  # Socket address collisions between tests
  enableParallelChecking = false;

  postFixup = lib.optionalString stdenv.isLinux ''
    for f in $out/lib/udev/rules.d/*.rules
    do
      substituteInPlace $f --replace "/bin/sh" "${bash}/bin/sh" \
                           --replace "/sbin/modprobe" "${kmod}/sbin/modprobe"
    done
  '';


  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 sheepforce ];
    platforms = platforms.unix;
  };
}
