{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig
, cudatoolkit, opencl-clhpp, ocl-icd, fftw, fftwFloat, mkl
, blas, openblas, boost, mesa, libGLU_combined
, freeimage, python
}:

let
  version = "3.6.4";

  clfftSource = fetchFromGitHub {
    owner = "arrayfire";
    repo = "clFFT";
    rev = "16925fb93338b3cac66490b5cf764953d6a5dac7";
    sha256 = "0y35nrdz7w4n1l17myhkni3hwm37z775xn6f76xmf1ph7dbkslsc";
    fetchSubmodules = true;
  };

  clblasSource = fetchFromGitHub {
    owner = "arrayfire";
    repo = "clBLAS";
    rev = "1f3de2ae5582972f665c685b18ef0df43c1792bb";
    sha256 = "154mz52r5hm0jrp5fqrirzzbki14c1jkacj75flplnykbl36ibjs";
    fetchSubmodules = true;
  };

  cl2hppSource = fetchurl {
    url = "https://github.com/KhronosGroup/OpenCL-CLHPP/releases/download/v2.0.10/cl2.hpp";
    sha256 = "1v4q0g6b6mwwsi0kn7kbjn749j3qafb9r4ld3zdq1163ln9cwnvw";
  };

in stdenv.mkDerivation {
  pname = "arrayfire";
  inherit version;

  src = fetchurl {
    url = "http://arrayfire.com/arrayfire_source/arrayfire-full-${version}.tar.bz2";
    sha256 = "1fin7a9rliyqic3z83agkpb8zlq663q6gdxsnm156cs8s7f7rc9h";
  };

  cmakeFlags = [
    "-DAF_BUILD_OPENCL=OFF"
    "-DAF_BUILD_EXAMPLES=OFF"
    "-DBUILD_TESTING=OFF"
    "-DCMAKE_LIBRARY_PATH=${cudatoolkit}/lib/stubs"
  ];

  patches = [ ./no-download.patch ];

  postPatch = ''
    mkdir -p ./build/third_party/clFFT/src
    cp -R --no-preserve=mode,ownership ${clfftSource}/ ./build/third_party/clFFT/src/clFFT-ext/
    mkdir -p ./build/third_party/clBLAS/src
    cp -R --no-preserve=mode,ownership ${clblasSource}/ ./build/third_party/clBLAS/src/clBLAS-ext/
    mkdir -p ./build/include/CL
    cp -R --no-preserve=mode,ownership ${cl2hppSource} ./build/include/CL/cl2.hpp
  '';

  preBuild = ''
    export CUDA_PATH="${cudatoolkit}"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    opencl-clhpp fftw fftwFloat
    mkl
    openblas
    libGLU_combined
    mesa freeimage
    boost.out boost.dev python
  ] ++ (stdenv.lib.optional stdenv.isLinux [ cudatoolkit ocl-icd ]);

  meta = with stdenv.lib; {
    description = "A general-purpose library that simplifies the process of developing software that targets parallel and massively-parallel architectures including CPUs, GPUs, and other hardware acceleration devices";
    license = licenses.bsd3;
    homepage = https://arrayfire.com/ ;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ chessai ];
    inherit version;
  };
}
