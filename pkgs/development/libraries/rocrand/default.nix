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
  pname = "rocrand";
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
    repo = "rocRAND";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-5kqVLUINYk8WjnRJ+LqUiCPjLIHcbvIL0Z6BRsj9hvY=";
    fetchSubmodules = true; # For inline hipRAND
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
    "-DCMAKE_C_COMPILER=hipcc"
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
    description = "Generate pseudo-random and quasi-random numbers";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocRAND";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
