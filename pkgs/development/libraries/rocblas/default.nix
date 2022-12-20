{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, fetchpatch
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, hip
, python3
, tensile
, msgpack
, libxml2
, llvm
, gtest
, gfortran
, python3Packages
, buildTensile ? true
, buildTests ? false
, buildBenchmarks ? false
, tensileLogic ? "asm_full"
, tensileCOVersion ? "V3"
, tensileSepArch ? true
, tensileLazyLib ? true
, tensileLibFormat ? "msgpack"
, gpuTargets ? [ "all" ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-4art8/KwH2KDLwSYcyzn/m/xwdg5wQQvgHks73aB+60=";
  };

  # We currently need this patch due to faulty toolchain includes
  # See: https://github.com/ROCmSoftwarePlatform/rocBLAS/issues/1277
  patches = [
    (fetchpatch {
      name = "only-std_norm-from-rocblas_complex.patch";
      url = "https://github.com/ROCmSoftwarePlatform/rocBLAS/commit/44b99c6df26002139ca9ec68ee1fc8899c7b001f.patch";
      hash = "sha256-vSZkVYY951fqfOThKFqnYBasWMblS6peEJZ6sFMCk9k=";
    })
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
    rocm-runtime
    rocm-device-libs
    rocm-comgr
    python3
  ] ++ lib.optionals buildTensile [
    msgpack
    libxml2
    llvm
    python3Packages.pyyaml
    python3Packages.msgpack
  ] ++ lib.optionals buildTests [
    gtest
    gfortran
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-Dpython=python3"
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    "-DBUILD_WITH_TENSILE=${if buildTensile then "ON" else "OFF"}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTensile [
    "-DVIRTUALENV_HOME_DIR=/build/source/tensile"
    "-DTensile_TEST_LOCAL_PATH=/build/source/tensile"
    "-DTensile_ROOT=/build/source/tensile/lib/python${python3.pythonVersion}/site-packages/Tensile"
    "-DTensile_LOGIC=${tensileLogic}"
    "-DTensile_CODE_OBJECT_VERSION=${tensileCOVersion}"
    "-DTensile_SEPARATE_ARCHITECTURES=${if tensileSepArch then "ON" else "OFF"}"
    "-DTensile_LAZY_LIBRARY_LOADING=${if tensileLazyLib then "ON" else "OFF"}"
    "-DTensile_LIBRARY_FORMAT=${tensileLibFormat}"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_CLIENTS_BENCHMARKS=ON"
  ];

  # Tensile REALLY wants to write to the nix directory if we include it normally
  # We need to manually fixup the path so tensile will generate .co and .dat files
  postPatch = lib.optionalString buildTensile ''
    export PATH=${llvm}/bin:$PATH
    cp -a ${tensile} tensile
    chmod +w -R tensile

    # Rewrap Tensile
    substituteInPlace tensile/bin/{.t*,.T*,*} \
      --replace "${tensile}" "/build/source/tensile"

    substituteInPlace CMakeLists.txt \
      --replace "include(virtualenv)" "" \
      --replace "virtualenv_install(\''${Tensile_TEST_LOCAL_PATH})" ""
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "BLAS implementation for ROCm platform";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocBLAS";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    # Tests and benchmarks are a can of worms that I will tackle in a different PR
    # It involves completely rewriting the amd-blis derivation
    broken = finalAttrs.version != hip.version || buildTests || buildBenchmarks;
  };
})
