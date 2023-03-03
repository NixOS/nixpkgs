{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocblas
, hip
, fmt
, gtest
, gfortran
, lapack-reference
, buildTests ? false
, buildBenchmarks ? false
, gpuTargets ? [ ] # gpuTargets = [ "gfx803" "gfx900" "gfx906:xnack-" ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocsolver";
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
    repo = "rocSOLVER";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-UHUcA9CVPuYFpE2DTvRrRMMj51yNPo5wMTKnByL2RTg=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ] ++ lib.optionals (buildTests || buildBenchmarks) [
    gfortran
  ];

  buildInputs = [
    rocblas
    fmt
  ] ++ lib.optionals buildTests [
    gtest
  ] ++ lib.optionals (buildTests || buildBenchmarks) [
    lapack-reference
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_CLIENTS_BENCHMARKS=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/rocsolver-test $test/bin
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    mv $out/bin/rocsolver-bench $benchmark/bin
  '' + lib.optionalString (buildTests || buildBenchmarks) ''
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm LAPACK implementation";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocSOLVER";
    license = with licenses; [ bsd2 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
