{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  cmake,
  pkg-config,
  cfitsio,
  curl,
  libusb1,
  kmod,
  zlib,
  boost,
  libev,
  libnova,
  libtheora,
  libxisf,
  libjpeg,
  gsl,
  fftw,
  rtl-sdr-librtlsdr,
  gtest,
  udevCheckHook,
  versionCheckHook,
  indi-full,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "indilib";
  version = "2.2.4.2";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DISO8UHrH0cjXe+xTAOdFRce61tOk0SS/CAdsen9cXA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  nativeInstallCheckInputs = [
    udevCheckHook
  ];

  buildInputs = [
    boost
    cfitsio
    curl
    fftw
    gsl
    libev
    libjpeg
    libnova
    libtheora
    libusb1
    libxisf
    rtl-sdr-librtlsdr
    zlib
  ];

  cmakeFlags = [
    "-DFIX_WARNINGS=OFF" # disable Werror, which can break the build on newer compilers
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck [
    "-DINDI_BUILD_UNITTESTS=ON"
    "-DINDI_BUILD_INTEGTESTS=ON"
  ];

  checkInputs = [ gtest ];

  # tests seem to be broken on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;
  doInstallCheck = true;

  # Socket address collisions between tests
  enableParallelChecking = false;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for f in $out/lib/udev/rules.d/*.rules
    do
      substituteInPlace $f --replace-quiet "/bin/sh" "${bash}/bin/sh" \
                           --replace-quiet "/sbin/modprobe" "${kmod}/sbin/modprobe"
    done
  '';

  passthru.tests = {
    # make sure 3rd party drivers compile with this indilib
    indi-full = indi-full.override {
      indilib = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "indiserver";
    maintainers = with lib.maintainers; [
      sheepforce
      returntoreality
    ];
    platforms = lib.platforms.unix;
  };
})
