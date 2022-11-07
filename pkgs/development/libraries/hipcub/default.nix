{ lib
, stdenv
, fetchFromGitHub
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, rocprim
, hip
, gtest ? null
, gbenchmark ? null
, buildTests ? false
, buildBenchmarks ? false
}:

assert buildTests -> gtest != null;
assert buildBenchmarks -> gbenchmark != null;

# CUB can also be used as a backend instead of rocPRIM.
stdenv.mkDerivation rec {
  pname = "hipcub";
  rocmVersion = "5.3.1";
  version = "2.12.0-${rocmVersion}";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "hipCUB";
    rev = "rocm-${rocmVersion}";
    hash = "sha256-/GMZKbMD1sZQCM2FulM9jiJQ8ByYZinn0C8d/deFh0g=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
    rocm-runtime
    rocm-device-libs
    rocm-comgr
    rocprim
  ] ++ lib.optionals buildTests [
    gtest
  ] ++ lib.optionals buildBenchmarks [
    gbenchmark
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

  meta = with lib; {
    description = "Thin wrapper library on top of rocPRIM or CUB";
    homepage = "https://github.com/ROCmSoftwarePlatform/hipCUB";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ Madouura ];
    broken = rocmVersion != hip.version;
  };
}
