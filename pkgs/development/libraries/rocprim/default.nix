{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, hip
, gtest
, gbenchmark
, buildTests ? false
, buildBenchmarks ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprim";
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
    repo = "rocPRIM";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-VGTrMllQguIJKexdQNXC07KX7TxU/e5oT6VZdlSRcQY=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = lib.optionals buildTests [
    gtest
  ] ++ lib.optionals buildBenchmarks [
    gbenchmark
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DBUILD_TEST=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_BENCHMARK=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/test_* $test/bin
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    mv $out/bin/benchmark_* $benchmark/bin
  '' + lib.optionalString (buildTests || buildBenchmarks) ''
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm parallel primitives";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocPRIM";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
