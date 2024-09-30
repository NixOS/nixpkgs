{ stdenv
, llvmPackages
, lib
, fetchFromGitHub
, cmake
, libffi
, libpng
, libjpeg
, mesa
, libGL
, eigen
, openblas
, blas
, lapack
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation rec {
  pname = "halide";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    rev = "v${version}";
    sha256 = "sha256-lJQrXkJgBmGb/QMSxwuPkkHOSgEDowLWzIolp1km2Y8=";
  };

  postPatch = ''
    # See https://github.com/halide/Halide/issues/7785
    substituteInPlace 'src/runtime/HalideRuntime.h' \
      --replace '#if defined(__x86_64__) || defined(__i386__) || defined(__arm__) || defined(__aarch64__)
    #define HALIDE_CPP_COMPILER_HAS_FLOAT16' \
                '#if defined(__x86_64__) || defined(__i386__)
    #define HALIDE_CPP_COMPILER_HAS_FLOAT16'
  ''
  # Note: on x86_64-darwin, clang fails to find AvailabilityVersions.h, so we remove it.
  # Halide uses AvailabilityVersions.h and TargetConditionals.h to determine whether
  # ::aligned_alloc is available. For us, it isn't.
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    substituteInPlace 'src/runtime/HalideBuffer.h' \
      --replace '#ifdef __APPLE__
    #include <AvailabilityVersions.h>
    #include <TargetConditionals.h>
    #endif' \
                ' ' \
      --replace 'TARGET_OS_OSX && (__MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_15)' \
                '1' \
      --replace 'TARGET_OS_IPHONE && (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_14_0)' \
                '0'
  '';

  cmakeFlags = [
    "-DWARNINGS_AS_ERRORS=OFF"
    "-DWITH_PYTHON_BINDINGS=OFF"
    "-DTARGET_WEBASSEMBLY=OFF"
    # Disable performance tests since they may fail on busy machines
    "-DWITH_TEST_PERFORMANCE=OFF"
    # Disable fuzzing tests -- this has become the default upstream after the
    # v16 release (See https://github.com/halide/Halide/commit/09c5d1d19ec8e6280ccbc01a8a12decfb27226ba)
    # These tests also fail to compile on Darwin because of some missing command line options...
    "-DWITH_TEST_FUZZ=OFF"
  ];

  doCheck = true;

  # Note: disable mullapudi2016_fibonacci because it requires too much
  # parallelism for remote builders
  preCheck = ''
    checkFlagsArray+=("ARGS=-E 'mullapudi2016_fibonacci'")
  '';

  # Note: only openblas and not atlas part of this Nix expression
  # see pkgs/development/libraries/science/math/liblapack/3.5.0.nix
  # to get a hint howto setup atlas instead of openblas
  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    llvmPackages.openmp
    llvmPackages.libclang
    libffi
    libpng
    libjpeg
    eigen
    openblas
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    mesa
    libGL
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ based language for image processing and computational photography";
    homepage = "https://halide-lang.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ck3d atila twesterhout ];
  };
}
