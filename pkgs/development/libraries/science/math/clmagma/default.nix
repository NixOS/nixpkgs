{ lib, stdenv, fetchurl, gfortran, opencl-headers, clblas, ocl-icd, mkl, intel-ocl }:

with lib;

let
  incfile = builtins.toFile "make.inc.custom" ''
    CC        = g++
    FORT      = gfortran

    ARCH      = ar
    ARCHFLAGS = cr
    RANLIB    = ranlib

    OPTS      = -fPIC -O3 -DADD_ -Wall
    FOPTS     = -fPIC -O3 -DADD_ -Wall -x f95-cpp-input
    F77OPTS   = -fPIC -O3 -DADD_ -Wall
    LDOPTS    = -fPIC

    -include make.check-mkl
    -include make.check-clblas

    # Gnu mkl is not available I guess?
    #LIB       = -lmkl_gf_lp64 -lmkl_gnu_thread -lmkl_core -lpthread -lm -fopenmp
    LIB        = -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lm -fopenmp
    LIB       += -lclBLAS -lOpenCL

    LIBDIR    = -L$(MKLROOT)/lib/intel64 \
                -L$(MKLROOT)/../compiler/lib/intel64 \
                -L$(clBLAS)/lib64

    INC       = -I$(clBLAS)/include
               #-I$(AMDAPP)/include
  '';
in stdenv.mkDerivation rec {
  pname = "clmagma";
  version = "1.3.0";
  src = fetchurl {
    url = "https://icl.cs.utk.edu/projectsfiles/magma/cl/clmagma-${version}.tar.gz";
    sha256 = "1n27ny0xhwirw2ydn46pfcwy53gzia9zbam4irx44fd4d7f9ydv7";
    name = "clmagma-${version}.tar.gz";
  };

  buildInputs = [
    gfortran
    clblas
    opencl-headers
    ocl-icd
    mkl
    intel-ocl
  ];

  enableParallelBuilding=true;

  MKLROOT   = "${mkl}";
  clBLAS    = "${clblas}";

  # Otherwise build looks for it in /run/opengl-driver/etc/OpenCL/vendors,
  # which is not available.
  OPENCL_VENDOR_PATH="${intel-ocl}/etc/OpenCL/vendors";

  preBuild = ''
    # By default it tries to use GPU, and thus fails for CPUs
    sed -i "s/CL_DEVICE_TYPE_GPU/CL_DEVICE_TYPE_DEFAULT/" interface_opencl/clmagma_runtime.cpp
    sed -i "s%/usr/local/clmagma%/$out%" Makefile.internal
    cp ${incfile} make.inc
  '';

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures, OpenCL port";
    license = licenses.bsd3;
    homepage = "https://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ volhovm ];
  };
}
