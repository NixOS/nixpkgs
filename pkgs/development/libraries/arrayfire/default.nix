{ lib, stdenv, fetchurl, fetchFromGitHub, cmake, pkg-config
, opencl-clhpp, ocl-icd, fftw, fftwFloat
, blas, lapack, boost, mesa, libGLU, libGL
, freeimage, python3, clfft, clblas
, doxygen, buildDocs ? false
, cudaSupport ? false, cudatoolkit
}:

stdenv.mkDerivation rec {
  pname = "arrayfire";
  version = "3.6.4";

  src = fetchurl {
    url = "http://arrayfire.com/arrayfire_source/arrayfire-full-${version}.tar.bz2";
    sha256 = "1fin7a9rliyqic3z83agkpb8zlq663q6gdxsnm156cs8s7f7rc9h";
  };

  cmakeFlags = [
    "-DAF_BUILD_OPENCL=OFF"
    "-DAF_BUILD_EXAMPLES=OFF"
    "-DBUILD_TESTING=OFF"
  ] ++ lib.optional cudaSupport "-DCMAKE_LIBRARY_PATH=${cudatoolkit}/lib/stubs";

  patches = [ ./no-download.patch ];

  postPatch = ''
    mkdir -p ./build/third_party/clFFT/src
    cp -R --no-preserve=mode,ownership ${clfft.src}/ ./build/third_party/clFFT/src/clFFT-ext/
    mkdir -p ./build/third_party/clBLAS/src
    cp -R --no-preserve=mode,ownership ${clblas.src}/ ./build/third_party/clBLAS/src/clBLAS-ext/
    mkdir -p ./build/include/CL
    cp -R --no-preserve=mode,ownership ${opencl-clhpp}/include/CL/cl2.hpp ./build/include/CL/cl2.hpp
  '';

  preBuild = lib.optionalString cudaSupport ''
    export CUDA_PATH="${cudatoolkit}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  strictDeps = true;

  buildInputs = [
    opencl-clhpp fftw fftwFloat
    blas lapack
    libGLU libGL
    mesa freeimage
    boost.out boost.dev
  ] ++ (lib.optional stdenv.isLinux ocl-icd)
    ++ (lib.optional cudaSupport cudatoolkit)
    ++ (lib.optional buildDocs doxygen);

  meta = with lib; {
    description = "A general-purpose library for parallel and massively-parallel computations";
    longDescription = ''
      A general-purpose library that simplifies the process of developing software that targets parallel and massively-parallel architectures including CPUs, GPUs, and other hardware acceleration devices.";
    '';
    license = licenses.bsd3;
    homepage = "https://arrayfire.com/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chessai ];
  };
}
