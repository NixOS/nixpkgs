{ stdenv
, fetchFromGitHub
, cmake
, gfortran
, blas
, boost
, python
, ocl-icd
, cudatoolkit
, nvidia_x11
, gtest
}:

stdenv.mkDerivation rec {
  name = "clblas-cuda-${version}"; 
  version = "git-20160505"; 

  src = fetchFromGitHub {
    owner = "clMathLibraries"; 
    repo = "clBLAS";
    rev = "d20977ec4389c6b3751e318779410007c5e272f8";
    sha256 = "1jna176cxznv7iz43svd6cjrbbf0fc2lrbpfpg4s08vc7xnwp0n4";
  }; 

  patches = [ ./platform.patch ]; 

  postPatch = ''
    sed -i -re 's/(set\(\s*Boost_USE_STATIC_LIBS\s+).*/\1OFF\ \)/g' src/CMakeLists.txt
  '';

  configurePhase = ''
    findInputs ${boost.dev} boost_dirs propagated-native-build-inputs

    export BOOST_INCLUDEDIR=$(echo $boost_dirs | sed -e s/\ /\\n/g - | grep '\-dev')/include
    export BOOST_LIBRARYDIR=$(echo $boost_dirs | sed -e s/\ /\\n/g - | grep -v '\-dev')/lib

    mkdir -p Build
    pushd Build

    export LD_LIBRARY_PATH="${stdenv.lib.makeLibraryPath [ blas nvidia_x11 ]}"

    cmake ../src -DCMAKE_INSTALL_PREFIX=$out \
                 -DCMAKE_BUILD_TYPE=Release \
                 -DOPENCL_ROOT=${cudatoolkit} \
                 -DUSE_SYSTEM_GTEST=ON
  '';

  dontStrip = true; 

  buildInputs = [
    cmake
    gfortran
    blas
    python
    ocl-icd
    cudatoolkit
    nvidia_x11
    gtest
  ]; 

  meta = with stdenv.lib; {
    homepage = https://github.com/clMathLibraries/clBLAS;
    description = "A software library containing BLAS functions written in OpenCL";
    longDescription = ''
      This package contains a library of BLAS functions on top of OpenCL. 
      The current version is linked to the NVIDIA OpenCL implementation provided by the CUDA toolkit. 
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };

}
