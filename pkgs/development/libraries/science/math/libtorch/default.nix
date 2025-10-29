{
  stdenv,
  config,
  lib,
  cmake,
  eigen,
  cpuinfo,
  fp16,
  fmt,
  gbenchmark,
  python3,
  python3Packages,
  protobuf,
  fetchFromGitHub,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  ...
}:
let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  pythonEnv = python3.withPackages (ps: [
    #ps.pybind11
    #ps.setuptools
    #ps.pip # not technically needed, but this makes setup.py invocation work

    ps.six # dependency chain: NNPACK -> PeachPy -> six
    ps.typing-extensions
    ps.pyyaml

    #ps.ninja
    #ps.numpy
    #ps.packaging
    #ps.requests
  ]);
in
effectiveStdenv.mkDerivation rec {
  name = "libtorch";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "pytorch";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Jszhe67FteiSbkbUEjVIkWVUjUY8IS5qVHct4HvcfIg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    cpuinfo
    fp16
    fmt
    gbenchmark
    protobuf
    pythonEnv
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.nccl
  ]
  ++ lib.optionals (!cudaSupport) [
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_CUDA" cudaSupport)
    (lib.cmakeBool "DBUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_PYTHON" false)
    (lib.cmakeBool "USE_SYSTEM_CPUINFO" true)
    (lib.cmakeBool "USE_SYSTEM_EIGEN_INSTALL" true)
    (lib.cmakeBool "USE_SYSTEM_FP16" true)
    (lib.cmakeBool "USE_SYSTEM_PYBIND11" true)
    (lib.cmakeBool "BUILD_CUSTOM_PROTOBUF" false)
    (lib.cmakeOptionType "path" "PYTHON_SIX_SOURCE_DIR"
      "${python3Packages.six}/${python3.sitePackages}/six"
    )
    (lib.cmakeOptionType "path" "PYTHON_EXECUTABLE" "${pythonEnv}/bin/python3")

  ];

  meta = with lib; {
    description = "C++ API of the PyTorch machine learning framework";
    homepage = "https://pytorch.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    maintainers = with maintainers; [ ]; # junjihashimoto
    platforms = [
      #"aarch64-darwin"
      "x86_64-linux"
    ];
  };
}
