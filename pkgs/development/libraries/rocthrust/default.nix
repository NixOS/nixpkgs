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
, buildTests ? false
, buildBenchmarks ? false
}:

assert buildTests -> gtest != null;

# Doesn't seem to work, thousands of errors compiling with no clear fix
# Is this an upstream issue? We don't seem to be missing dependencies
assert buildTests == false;
assert buildBenchmarks == false;

stdenv.mkDerivation rec {
  pname = "rocthrust";
  rocmVersion = "5.3.1";
  version = "2.16.0-${rocmVersion}";

  # Comment out these outputs until tests/benchmarks are fixed (upstream?)
  # outputs = [
  #   "out"
  # ] ++ lib.optionals buildTests [
  #   "test"
  # ] ++ lib.optionals buildBenchmarks [
  #   "benchmark"
  # ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocThrust";
    rev = "rocm-${rocmVersion}";
    hash = "sha256-cT0VyEVz86xR6qubAY2ncTxtCRTwXrNTWcFyf3mV+y0=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    rocprim
    hip
  ];

  buildInputs = [
    rocm-runtime
    rocm-device-libs
    rocm-comgr
  ] ++ lib.optionals buildTests [
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
  ];

  # Comment out these outputs until tests/benchmarks are fixed (upstream?)
  # postInstall = lib.optionalString buildTests ''
  #   mkdir -p $test/bin
  #   mv $out/bin/test_* $test/bin
  # '' + lib.optionalString buildBenchmarks ''
  #   mkdir -p $benchmark/bin
  #   mv $out/bin/benchmark_* $benchmark/bin
  # '' + lib.optionalString (buildTests || buildBenchmarks) ''
  #   rmdir $out/bin
  # '';

  meta = with lib; {
    description = "ROCm parallel algorithm library";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocThrust";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ Madouura ];
    broken = rocmVersion != hip.version;
  };
}
