{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  bash,
  cmake,
  cfitsio,
  libusb1,
  kmod,
  zlib,
  boost,
  libev,
  libnova,
  curl,
  libjpeg,
  gsl,
  fftw,
  gtest,
  udevCheckHook,
  versionCheckHook,
  indi-full,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "indilib";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0+ZC9NoanBDojYz/ufZUpUQB++vnMcUYtG1UmmVGbTg=";
  };

  # fixes version number. This commit is directly after the tagged commit in master
  # should be removed with the next release
  patches = [
    (fetchpatch2 {
      url = "https://github.com/indilib/indi/commit/91e3e35250126887a856e90b6a0a30697fb01545.patch?full_index=1";
      hash = "sha256-ho1S+A6gTQ9ELy/QE14S6daXyMN+vASFbXa2vMWdqR8=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    udevCheckHook
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
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck [
    "-DINDI_BUILD_UNITTESTS=ON"
    "-DINDI_BUILD_INTEGTESTS=ON"
  ];

  checkInputs = [ gtest ];

  doCheck = true;
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

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${finalAttrs.version}";
    license = licenses.lgpl2Plus;
    mainProgram = "indiserver";
    maintainers = with maintainers; [
      sheepforce
      returntoreality
    ];
    platforms = platforms.unix;
  };
})
