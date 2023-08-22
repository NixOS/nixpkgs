{ blas
, boost
, cmake
, config
, cudaPackages
, fetchFromGitHub
, fftw
, fftwFloat
, fmt_9
, forge
, freeimage
, git
, gtest
, lapack
, lib
, libGL
, mesa
, ocl-icd
, opencl-clhpp
, pkg-config
, python3
, span-lite
, stdenv
, doCheck ? false
, withCPU ? true
, withCuda ? config.cudaSupport
, withOpenCL ? stdenv.isLinux
, nvidiaComputeDrivers ? null
}:

assert blas.isILP64 == false;

stdenv.mkDerivation rec {
  pname = "arrayfire";
  version = "3.9.0-pre";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "d2a66367d859cdb554f2374e29d39c88d5fff978";
    hash = "sha256-9r1w0U9MvhduHwBpEWpqkrQPawd94EY3FAqSJghi09I=";
  };

  assets = fetchFromGitHub {
    owner = pname;
    repo = "assets";
    rev = "cd08d749611b324012555ad6f23fd76c5465bd6c";
    sha256 = "sha256-v4uhqPz1P1g1430FTmMp22xJS50bb5hZTeEX49GgMWg=";
  };
  clblast = fetchFromGitHub {
    owner = "cnugteren";
    repo = "CLBlast";
    rev = "4500a03440e2cc54998c0edab366babf5e504d67";
    sha256 = "sha256-I25ylQp6kHZx6Q7Ph5r3abWlQ6yeIHIDdS1eGCyArZ0=";
  };
  clfft = fetchFromGitHub {
    owner = pname;
    repo = "clfft";
    rev = "760096b37dcc4f18ccd1aac53f3501a83b83449c";
    sha256 = "sha256-vJo1YfC2AJIbbRj/zTfcOUmi0Oj9v64NfA9MfK8ecoY=";
  };
  glad = fetchFromGitHub {
    owner = pname;
    repo = "glad";
    rev = "ef8c5508e72456b714820c98e034d9a55b970650";
    sha256 = "sha256-u9Vec7XLhE3xW9vzM7uuf+b18wZsh/VMtGbB6nMVlno=";
  };
  threads = fetchFromGitHub {
    owner = pname;
    repo = "threads";
    rev = "4d4a4f0384d1ac2f25b2c4fc1d57b9e25f4d6818";
    sha256 = "sha256-qqsT9woJDtQvzuV323OYXm68pExygYs/+zZNmg2sN34=";
  };
  test-data = fetchFromGitHub {
    owner = pname;
    repo = "arrayfire-data";
    rev = "a5f533d7b864a4d8f0dd7c9aaad5ff06018c4867";
    sha256 = "sha256-AWzhsrDXyZrQN2bd0Ng/XlE8v02x7QWTiFTyaAuRXSw=";
  };
  cub = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cub";
    rev = "1.10.0";
    sha256 = "sha256-JyyNaTrtoSGiMP7tVUu9lFL07lyfJzRTVtx8yGy6/BI=";
  };
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v1.9.2";
    hash = "sha256-GSUdHtvV/97RyDKy8i+ticnSlQCubGGWHg4Oo+YAr8Y=";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
    "-DAF_BUILD_EXAMPLES=OFF"
    "-DAF_COMPUTE_LIBRARY='FFTW/LAPACK/BLAS'"
    "-DAF_TEST_WITH_MTX_FILES=OFF"
    "-DAF_WITH_SPDLOG_HEADER_ONLY=ON"
    "-DAF_BUILD_FORGE=OFF"
    (if withCPU then "-DAF_BUILD_CPU=ON" else "-DAF_BUILD_CPU=OFF")
    (if withOpenCL then "-DAF_BUILD_OPENCL=ON" else "-DAF_BUILD_OPENCL=OFF")
    (if withCuda then "-DAF_BUILD_CUDA=ON" else "-DAF_BUILD_CUDA=OFF")
  ] ++ lib.optionals withCuda [
    "-DCUDA_LIBRARIES_PATH=${cudaPackages.cudatoolkit}/lib"
  ];

  postPatch = ''
    mkdir -p ./extern/af_glad-src
    mkdir -p ./extern/af_threads-src
    mkdir -p ./extern/af_assets-src
    mkdir -p ./extern/af_test_data-src
    mkdir -p ./extern/ocl_clfft-src
    mkdir -p ./extern/ocl_clblast-src
    mkdir -p ./extern/nv_cub-src
    mkdir -p ./extern/spdlog-src
    cp -R --no-preserve=mode,ownership ${glad}/* ./extern/af_glad-src/
    cp -R --no-preserve=mode,ownership ${threads}/* ./extern/af_threads-src/
    cp -R --no-preserve=mode,ownership ${assets}/* ./extern/af_assets-src/
    cp -R --no-preserve=mode,ownership ${test-data}/* ./extern/af_test_data-src/
    cp -R --no-preserve=mode,ownership ${clfft}/* ./extern/ocl_clfft-src/
    cp -R --no-preserve=mode,ownership ${clblast}/* ./extern/ocl_clblast-src/
    cp -R --no-preserve=mode,ownership ${cub}/* ./extern/nv_cub-src/
    cp -R --no-preserve=mode,ownership ${spdlog}/* ./extern/spdlog-src/

    substituteInPlace src/api/unified/symbol_manager.cpp \
      --replace '"/opt/arrayfire-3/lib/",' \
                "\"$out/lib/\", \"/opt/arrayfire-3/lib/\","
  '';

  inherit doCheck;
  checkPhase =
    let
      LD_LIBRARY_PATH = builtins.concatStringsSep ":" (
        [ "${forge}/lib" "${freeimage}/lib" ]
        ++ lib.optional withCuda "${cudaPackages.cudatoolkit}/lib64"
        ++ lib.optional (nvidiaComputeDrivers != null) "${nvidiaComputeDrivers}/lib"
      );
      ctestFlags = builtins.concatStringsSep " " (
        [ "--output-on-errors" "-j1" ]
        # See https://github.com/arrayfire/arrayfire/issues/3484
        ++ lib.optional withOpenCL "-E '(inverse_dense|cholesky_dense)'"
      );
    in
    ''
      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
    '' + lib.optionalString (withOpenCL && nvidiaComputeDrivers != null) ''
      export OCL_ICD_VENDORS=${nvidiaComputeDrivers}/etc/OpenCL/vendors
    '' + ''
      AF_TRACE=all AF_PRINT_ERRORS=1 ctest ${ctestFlags}
    '';

  buildInputs = [
    blas
    boost.dev
    boost.out
    fftw
    fftwFloat
    fmt_9
    forge
    freeimage
    gtest
    lapack
    libGL
    ocl-icd
    opencl-clhpp
    span-lite
  ]
  ++ lib.optionals withCuda [
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
  ]
  ++ lib.optionals withOpenCL [
    mesa
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    python3
  ];

  meta = with lib; {
    description = "A general-purpose library for parallel and massively-parallel computations";
    longDescription = ''
      A general-purpose library that simplifies the process of developing software that targets parallel and massively-parallel architectures including CPUs, GPUs, and other hardware acceleration devices.";
    '';
    license = licenses.bsd3;
    homepage = "https://arrayfire.com/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chessai twesterhout ];
  };
}
