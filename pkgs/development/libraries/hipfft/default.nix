{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, hip
, git
, rocfft
, gtest
, boost
, fftw
, fftwFloat
, openmp
, buildTests ? false
, buildBenchmarks ? false
, buildSamples ? false
}:

# Can also use cuFFT
stdenv.mkDerivation (finalAttrs: {
  pname = "hipfft";
  version = "5.4.1";

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
    repo = "hipFFT";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-yDtm9J0wqH6zo4HcgQbqhvwbzbOiJPQ48gJ2gC8PvjA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    hip
    git
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocfft
  ] ++ lib.optionals (buildTests || buildBenchmarks || buildSamples) [
    gtest
    boost
    fftw
    fftwFloat
    openmp
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DCMAKE_MODULE_PATH=${hip}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${hip}"
    "-DHIP_PATH=${hip}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_CLIENTS_RIDER=ON"
  ] ++ lib.optionals buildSamples [
    "-DBUILD_CLIENTS_SAMPLES=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/hipfft-test $test/bin
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    mv $out/bin/hipfft-rider $benchmark/bin
  '' + lib.optionalString buildSamples ''
    mkdir -p $sample/bin
    mv clients/staging/hipfft_* $sample/bin
    patchelf $sample/bin/hipfft_* --shrink-rpath --allowed-rpath-prefixes /nix/store
  '' + lib.optionalString (buildTests || buildBenchmarks) ''
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "FFT marshalling library";
    homepage = "https://github.com/ROCmSoftwarePlatform/hipFFT";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.version != hip.version;
  };
})
