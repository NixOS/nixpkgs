{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocprim
, hip
, gtest
, buildTests ? false
, buildBenchmarks ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocthrust";
  version = "5.4.1";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocThrust";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-3OcJUL6T1HJz6TQb1//lumsTxqfwbWbQ4lGuZoKmqbY=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    rocprim
    hip
  ];

  buildInputs = lib.optionals buildTests [
    gtest
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DHIP_ROOT_DIR=${hip}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DBUILD_TEST=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_BENCHMARKS=ON"
  ] ++ lib.optionals (buildTests || buildBenchmarks) [
    "-DCMAKE_CXX_FLAGS=-Wno-deprecated-builtins" # Too much spam
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/{test_*,*.hip} $test/bin
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    mv $out/bin/benchmark_* $benchmark/bin
  '' + lib.optionalString (buildTests || buildBenchmarks) ''
    rm -rf $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm parallel algorithm library";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocThrust";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
