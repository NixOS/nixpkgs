{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, hip
, gtest ? null
, gbenchmark ? null
, buildTests ? false
, buildBenchmarks ? false
}:

assert buildTests -> gtest != null;
assert buildBenchmarks -> gbenchmark != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprim";
  repoVersion = "2.11.1";
  rocmVersion = "5.3.3";
  version = "${finalAttrs.repoVersion}-${finalAttrs.rocmVersion}";

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
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-jfTuGEPyssARpdo0ZnfVJt0MBkoHnmBtf6Zg4xXNJ1U=";
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
  ] ++ lib.optionals buildTests [
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

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    json="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rocPRIM/releases?per_page=1")"
    repoVersion="$(echo "$json" | jq '.[0].name | split(" ") | .[1]' --raw-output)"
    rocmVersion="$(echo "$json" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocprim "$repoVersion" --ignore-same-hash --version-key=repoVersion
    update-source-version rocprim "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "ROCm parallel primitives";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocPRIM";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})
