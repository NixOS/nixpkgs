{ lib
, stdenv
, fetchFromGitHub
, writeScript
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

stdenv.mkDerivation (finalAttrs: {
  pname = "rocthrust";
  repoVersion = "2.16.0";
  rocmVersion = "5.3.3";
  version = "${finalAttrs.repoVersion}-${finalAttrs.rocmVersion}";

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
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-WODOeWWL0AOYu0djwDlVZuiJDxcchsAT7BFG9JKYScw=";
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

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    json="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rocThrust/releases?per_page=1")"
    repoVersion="$(echo "$json" | jq '.[0].name | split(" ") | .[1]' --raw-output)"
    rocmVersion="$(echo "$json" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocthrust "$repoVersion" --ignore-same-hash --version-key=repoVersion
    update-source-version rocthrust "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "ROCm parallel algorithm library";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocThrust";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})
