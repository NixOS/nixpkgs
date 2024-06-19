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
, indi-full
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "indilib";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qdPQMC8HCMdcbHyO8B0OFiefO+jM1ytA2dYNymE0Xuc=";
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
  ] ++ lib.optional finalAttrs.finalPackage.doCheck [
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

  passthru.tests = {
    # make sure 3rd party drivers compile with this indilib
    indi-full = indi-full.override {
      indilib = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${finalAttrs.version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 sheepforce ];
    platforms = platforms.unix;
  };
})
