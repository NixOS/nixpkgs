<<<<<<< HEAD
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
=======
{ llvmPackages
, lib
, fetchFromGitHub
, cmake
, libpng
, libjpeg
, mesa
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, eigen
, openblas
, blas
, lapack
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

<<<<<<< HEAD
stdenv.mkDerivation rec {
=======
llvmPackages.stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "halide";
  version = "15.0.1";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    rev = "v${version}";
    sha256 = "sha256-mnZ6QMqDr48bH2W+andGZj2EhajXKApjuW6B50xtzx0=";
  };

<<<<<<< HEAD
  cmakeFlags = [
    "-DWARNINGS_AS_ERRORS=OFF"
    "-DWITH_PYTHON_BINDINGS=OFF"
    "-DTARGET_WEBASSEMBLY=OFF"
    # Disable performance tests since they may fail on busy machines
    "-DWITH_TEST_PERFORMANCE=OFF"
  ];

  doCheck = true;
=======
  cmakeFlags = [ "-DWARNINGS_AS_ERRORS=OFF" "-DWITH_PYTHON_BINDINGS=OFF" "-DTARGET_WEBASSEMBLY=OFF" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Note: only openblas and not atlas part of this Nix expression
  # see pkgs/development/libraries/science/math/liblapack/3.5.0.nix
  # to get a hint howto setup atlas instead of openblas
  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    llvmPackages.openmp
    llvmPackages.libclang
<<<<<<< HEAD
    libffi
    libpng
    libjpeg
    eigen
    openblas
  ] ++ lib.optionals (!stdenv.isDarwin) [
    mesa
    libGL
=======
    libpng
    libjpeg
    mesa
    eigen
    openblas
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ based language for image processing and computational photography";
    homepage = "https://halide-lang.org";
    license = licenses.mit;
    platforms = platforms.all;
<<<<<<< HEAD
    maintainers = with maintainers; [ ck3d atila twesterhout ];
=======
    maintainers = with maintainers; [ ck3d atila ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
