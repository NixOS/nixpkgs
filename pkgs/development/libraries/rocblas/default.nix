{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, hip
, python3
, tensile
, msgpack
, libxml2
, gtest
, gfortran
, openmp
, amd-blis
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
  version = "5.4.2";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-4art8/KwH2KDLwSYcyzn/m/xwdg5wQQvgHks73aB+60=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
    python3
  ] ++ lib.optionals buildTensile [
    msgpack
    libxml2
    python3Packages.msgpack
  ] ++ lib.optionals buildTests [
    gtest
  ] ++ lib.optionals (buildTests || buildBenchmarks) [
    gfortran
    openmp
    amd-blis
  ] ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
    python3Packages.pyyaml
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
  ] ++ lib.optionals (buildTests || buildBenchmarks) [
    "-DCMAKE_CXX_FLAGS=-I${amd-blis}/include/blis"
  ];

  # Tensile REALLY wants to write to the nix directory if we include it normally
  postPatch = lib.optionalString buildTensile ''
    cp -a ${tensile} tensile
    chmod +w -R tensile

    # Rewrap Tensile
    substituteInPlace tensile/bin/{.t*,.T*,*} \
      --replace "${tensile}" "/build/source/tensile"

    substituteInPlace CMakeLists.txt \
      --replace "include(virtualenv)" "" \
      --replace "virtualenv_install(\''${Tensile_TEST_LOCAL_PATH})" ""
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    cp -a $out/bin/* $test/bin
    rm $test/bin/*-bench || true
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    cp -a $out/bin/* $benchmark/bin
    rm $benchmark/bin/*-test || true
  '' + lib.optionalString (buildTests || buildBenchmarks ) ''
    rm -rf $out/bin
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
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
