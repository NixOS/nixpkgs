{ stdenv
, fetchFromGitHub
, cmake
, gfortran
, blas
, boost
, python
, ocl-icd
, opencl-headers
, gtest
}:

stdenv.mkDerivation rec {
  name = "clblas-${version}"; 
  version = "2.12";

  src = fetchFromGitHub {
    owner = "clMathLibraries"; 
    repo = "clBLAS";
    rev = "v${version}";
    sha256 = "154mz52r5hm0jrp5fqrirzzbki14c1jkacj75flplnykbl36ibjs";
  }; 

  patches = [ ./platform.patch ]; 

  postPatch = ''
    sed -i -re 's/(set\(\s*Boost_USE_STATIC_LIBS\s+).*/\1OFF\ \)/g' src/CMakeLists.txt
  '';

  preConfigure = ''
    cd src
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_GTEST=ON"
  ];

  buildInputs = [
    cmake
    gfortran
    blas
    python
    ocl-icd
    opencl-headers
    boost
    gtest
  ]; 

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/clMathLibraries/clBLAS";
    description = "A software library containing BLAS functions written in OpenCL";
    longDescription = ''
      This package contains a library of BLAS functions on top of OpenCL. 
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };

}
