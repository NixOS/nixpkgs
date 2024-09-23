{ blas
, boost
, clblast
, cmake
, config
, cudaPackages
, fetchFromGitHub
, fftw
, fftwFloat
, fmt_9
, forge
, freeimage
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
  # NOTE: We disable tests by default, because they cannot be run easily on
  # non-NixOS systems when either CUDA or OpenCL support is enabled (CUDA and
  # OpenCL need access to drivers that are installed outside of Nix on
  # non-NixOS systems).
, doCheck ? false
, cpuSupport ? true
, cudaSupport ? config.cudaSupport
  # OpenCL needs mesa which is broken on Darwin
, openclSupport ? !stdenv.isDarwin
  # This argument lets one run CUDA & OpenCL tests on non-NixOS systems by
  # telling Nix where to find the drivers. If you know the version of the
  # Nvidia driver that is installed on your system, you can do:
  #
  # arrayfire.override {
  #   nvidiaComputeDrivers =
  #     callPackage
  #       (prev.linuxPackages.nvidiaPackages.mkDriver {
  #         version = cudaVersion; # our driver version
  #         sha256_64bit = cudaHash; # sha256 of the .run binary
  #         useGLVND = false;
  #         useProfiles = false;
  #         useSettings = false;
  #         usePersistenced = false;
  #         ...
  #       })
  #       { libsOnly = true; };
  # }
, nvidiaComputeDrivers ? null
, fetchpatch
}:

# ArrayFire compiles with 64-bit BLAS, but some tests segfault or throw
# exceptions, which means that it isn't really supported yet...
assert blas.isILP64 == false;

stdenv.mkDerivation rec {
  pname = "arrayfire";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v3.9.0";
    hash = "sha256-80fxdkaeAQ5u0X/UGPaI/900cdkZ/vXNcOn5tkZ+C3Y=";
  };

  # We cannot use the clfft from Nixpkgs because ArrayFire maintain a fork
  # of clfft where they've modified the CMake build system, and the
  # CMakeLists.txt of ArrayFire assumes that we're using that fork.
  #
  # This can be removed once ArrayFire upstream their changes.
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
  # ArrayFire fails to compile with newer versions of spdlog, so we can't use
  # the one in Nixpkgs. Once they upgrade, we can switch to using spdlog from
  # Nixpkgs.
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v1.9.2";
    hash = "sha256-GSUdHtvV/97RyDKy8i+ticnSlQCubGGWHg4Oo+YAr8Y=";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
    # We do not build examples, because building tests already takes long enough...
    "-DAF_BUILD_EXAMPLES=OFF"
    # No need to build forge, because it's a separate package
    "-DAF_BUILD_FORGE=OFF"
    "-DAF_COMPUTE_LIBRARY='FFTW/LAPACK/BLAS'"
    # Prevent ArrayFire from trying to download some matrices from the Internet
    "-DAF_TEST_WITH_MTX_FILES=OFF"
    # Have to use the header-only version, because we're not using the version
    # from Nixpkgs. Otherwise, libaf.so won't be able to find the shared
    # library, because ArrayFire's CMake files do not run the install step of
    # spdlog.
    "-DAF_WITH_SPDLOG_HEADER_ONLY=ON"
    (if cpuSupport then "-DAF_BUILD_CPU=ON" else "-DAF_BUILD_CPU=OFF")
    (if openclSupport then "-DAF_BUILD_OPENCL=ON" else "-DAF_BUILD_OPENCL=OFF")
    (if cudaSupport then "-DAF_BUILD_CUDA=ON" else "-DAF_BUILD_CUDA=OFF")
  ] ++ lib.optionals cudaSupport [
    # ArrayFire use deprecated FindCUDA in their CMake files, so we help CMake
    # locate cudatoolkit.
    "-DCUDA_LIBRARIES_PATH=${cudaPackages.cudatoolkit}/lib"
  ];

  # ArrayFire have a repo with assets for the examples. Since we don't build
  # the examples anyway, remove the dependency on assets.
  patches = [
    ./no-assets.patch
    ./no-download.patch
    # Fix for newer opencl-clhpp. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/arrayfire/arrayfire/pull/3562.patch";
      hash = "sha256-AdWlpcRTn9waNAaVpZfK6sJ/xBQLiBC4nBeEYiGNN50";
    })
  ];

  postPatch = ''
    mkdir -p ./extern/af_glad-src
    mkdir -p ./extern/af_threads-src
    mkdir -p ./extern/af_test_data-src
    mkdir -p ./extern/ocl_clfft-src
    mkdir -p ./extern/spdlog-src
    cp -R --no-preserve=mode,ownership ${glad}/* ./extern/af_glad-src/
    cp -R --no-preserve=mode,ownership ${threads}/* ./extern/af_threads-src/
    cp -R --no-preserve=mode,ownership ${test-data}/* ./extern/af_test_data-src/
    cp -R --no-preserve=mode,ownership ${clfft}/* ./extern/ocl_clfft-src/
    cp -R --no-preserve=mode,ownership ${spdlog}/* ./extern/spdlog-src/

    # libaf.so (the unified backend) tries to load the right shared library at
    # runtime, and the search paths are hard-coded... We tweak them to point to
    # the installation directory in the Nix store.
    substituteInPlace src/api/unified/symbol_manager.cpp \
      --replace '"/opt/arrayfire-3/lib/",' \
                "\"$out/lib/\", \"/opt/arrayfire-3/lib/\","
  '';

  inherit doCheck;
  checkPhase =
    let
      LD_LIBRARY_PATH = builtins.concatStringsSep ":" (
        [ "${forge}/lib" "${freeimage}/lib" ]
        ++ lib.optional cudaSupport "${cudaPackages.cudatoolkit}/lib64"
        # On non-NixOS systems, help the tests find Nvidia drivers
        ++ lib.optional (nvidiaComputeDrivers != null) "${nvidiaComputeDrivers}/lib"
      );
      ctestFlags = builtins.concatStringsSep " " (
        # We have to run with "-j1" otherwise various segfaults occur on non-NixOS systems.
        [ "--output-on-errors" "-j1" ]
        # See https://github.com/arrayfire/arrayfire/issues/3484
        ++ lib.optional openclSupport "-E '(inverse_dense|cholesky_dense)'"
      );
    in
    ''
      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
    '' +
    # On non-NixOS systems, help the tests find Nvidia drivers
    lib.optionalString (openclSupport && nvidiaComputeDrivers != null) ''
      export OCL_ICD_VENDORS=${nvidiaComputeDrivers}/etc/OpenCL/vendors
    '' + ''
      # Note: for debugging, enable AF_TRACE=all
      AF_PRINT_ERRORS=1 ctest ${ctestFlags}
    '';

  buildInputs = [
    blas
    boost.dev
    boost.out
    clblast
    fftw
    fftwFloat
    # We need fmt_9 because ArrayFire fails to compile with newer versions.
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
  ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cccl
  ]
  ++ lib.optionals openclSupport [
    mesa
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  meta = with lib; {
    description = "General-purpose library for parallel and massively-parallel computations";
    longDescription = ''
      A general-purpose library that simplifies the process of developing software that targets parallel and massively-parallel architectures including CPUs, GPUs, and other hardware acceleration devices.";
    '';
    license = licenses.bsd3;
    homepage = "https://arrayfire.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ chessai twesterhout ];
  };
}
