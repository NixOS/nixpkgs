{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, hip
, gfortran
, rocblas
, rocsolver
, gtest
, lapack-reference
, buildTests ? false
, buildBenchmarks ? false
, buildSamples ? false
}:

# Can also use cuSOLVER
stdenv.mkDerivation (finalAttrs: {
  pname = "hipsolver";
  version = "5.4.4";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ] ++ lib.optionals buildSamples [
    "sample"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "hipSOLVER";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-p9hgKqRALLItv/HTpVlTsu+m9wlwCBYPYnJcm8StIao=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
    gfortran
  ];

  buildInputs = [
    rocblas
    rocsolver
  ] ++ lib.optionals buildTests [
    gtest
  ] ++ lib.optionals (buildTests || buildBenchmarks) [
    lapack-reference
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_CLIENTS_BENCHMARKS=ON"
  ] ++ lib.optionals buildSamples [
    "-DBUILD_CLIENTS_SAMPLES=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/hipsolver-test $test/bin
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    mv $out/bin/hipsolver-bench $benchmark/bin
  '' + lib.optionalString buildSamples ''
    mkdir -p $sample/bin
    mv clients/staging/example-* $sample/bin
    patchelf $sample/bin/example-* --shrink-rpath --allowed-rpath-prefixes /nix/store
  '' + lib.optionalString (buildTests || buildBenchmarks) ''
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm SOLVER marshalling library";
    homepage = "https://github.com/ROCmSoftwarePlatform/hipSOLVER";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
