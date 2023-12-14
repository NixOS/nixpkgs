{ stdenv
, lib
, fetchFromGitHub
, cmake
, gfortran
, fftwSinglePrec
, doxygen
, swig
, enablePython ? false
, python3Packages
, enableOpencl ? true
, opencl-headers
, ocl-icd
, config
, enableCuda ? config.cudaSupport
, cudaPackages
, addOpenGLRunpath
}:

stdenv.mkDerivation rec {
  pname = "openmm";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "openmm";
    repo = pname;
    rev = version;
    hash = "sha256-uNAqjklgBWM2v2z6qu17ZMFO4gn3fsnYPxyGO++UtTw=";
  };

  # "This test is stochastic and may occassionally fail". It does.
  postPatch = ''
    rm \
      platforms/*/tests/Test*BrownianIntegrator.* \
      platforms/*/tests/Test*LangevinIntegrator.* \
      serialization/tests/TestSerializeIntegrator.cpp
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    swig
    doxygen
    python3Packages.python
  ] ++ lib.optional enableCuda addOpenGLRunpath;

  buildInputs = [ fftwSinglePrec ]
    ++ lib.optionals enableOpencl [ ocl-icd opencl-headers ]
    ++ lib.optional enableCuda cudaPackages.cudatoolkit;

  propagatedBuildInputs = lib.optionals enablePython (with python3Packages; [
    setuptools
    python
    numpy
    cython
  ]);

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
    "-DOPENMM_BUILD_AMOEBA_PLUGIN=ON"
    "-DOPENMM_BUILD_CPU_LIB=ON"
    "-DOPENMM_BUILD_C_AND_FORTRAN_WRAPPERS=ON"
    "-DOPENMM_BUILD_DRUDE_PLUGIN=ON"
    "-DOPENMM_BUILD_PME_PLUGIN=ON"
    "-DOPENMM_BUILD_RPMD_PLUGIN=ON"
    "-DOPENMM_BUILD_SHARED_LIB=ON"
  ] ++ lib.optionals enablePython [
    "-DOPENMM_BUILD_PYTHON_WRAPPERS=ON"
  ] ++ lib.optionals enableOpencl [
    "-DOPENMM_BUILD_OPENCL_LIB=ON"
    "-DOPENMM_BUILD_AMOEBA_OPENCL_LIB=ON"
    "-DOPENMM_BUILD_DRUDE_OPENCL_LIB=ON"
    "-DOPENMM_BUILD_RPMD_OPENCL_LIB=ON"
  ] ++ lib.optionals enableCuda [
    "-DCUDA_SDK_ROOT_DIR=${cudaPackages.cudatoolkit}"
    "-DOPENMM_BUILD_AMOEBA_CUDA_LIB=ON"
    "-DOPENMM_BUILD_CUDA_LIB=ON"
    "-DOPENMM_BUILD_DRUDE_CUDA_LIB=ON"
    "-DOPENMM_BUILD_RPMD_CUDA_LIB=ON"
    "-DCMAKE_LIBRARY_PATH=${cudaPackages.cudatoolkit}/lib64/stubs"
  ];

  postInstall = lib.strings.optionalString enablePython ''
      export OPENMM_LIB_PATH=$out/lib
      export OPENMM_INCLUDE_PATH=$out/include
      cd python
      ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py build
      ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py install --prefix=$out
      mv $out/lib/python*/site-packages/OpenMM*.egg/{openmm,simtk} $out/lib/python*/site-packages/.
    '';

  postFixup = ''
    for lib in $out/lib/plugins/*CUDA.so $out/lib/plugins/*Cuda*.so; do
      addOpenGLRunpath "$lib"
    done
  '';

  # Couldn't get CUDA to run properly in the sandbox
  doCheck = !enableCuda && !enableOpencl;

  meta = with lib; {
    description = "Toolkit for molecular simulation using high performance GPU code";
    homepage = "https://openmm.org/";
    license = with licenses; [ gpl3Plus lgpl3Plus mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
