{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gitMinimal,
  bison,
  flex,
  curl,
  nlohmann_json,
  openssl,
  boost,
  openblas,
  aws-sdk-cpp,
  faiss,
  zlib,
  llvmPackages_20,
}:

# TuringDB requires LLVM 20 if on aarch Darwin
let
  turingstdenv = if stdenv.isDarwin then llvmPackages_20.stdenv else stdenv;
in
turingstdenv.mkDerivation (finalAttrs: {
  pname = "turingdb";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "turing-db";
    repo = "turingdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gG3KzEC90nLbIisBt4xnHXtz6LesqJxaviIkTrcTMG0=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      git -C $out log -1 --format=%ct > $out/HEAD_COMMIT_TIMESTAMP
      rm -rf $out/.git
    '';
  };

  postPatch = ''
    substituteInPlace storage/dump/DumpConfig.h \
      --replace-fail HEAD_COMMIT_TIMESTAMP "$(cat $src/HEAD_COMMIT_TIMESTAMP)"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    aws-sdk-cpp
    boost
    curl
    faiss
    nlohmann_json
    openblas
    openssl
    zlib
  ]
  ++ lib.optionals turingstdenv.isDarwin [ llvmPackages_20.openmp ];

  cmakeFlags = [
    (lib.cmakeBool "NIX_BUILD" true) # CMake flag for top-level turingdb CMakeLists
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-fopenmp")
  ]
  ++ lib.optionals stdenv.isDarwin [
    (lib.cmakeFeature "OpenMP_CXX_FLAGS" "-fopenmp")
    (lib.cmakeFeature "OpenMP_CXX_LIB_NAMES" "omp")
    (lib.cmakeFeature "OpenMP_omp_LIBRARY" "${lib.getLib llvmPackages_20.openmp}/lib/libomp.dylib")
  ];

  # Tests are disabled because they require network access and external dependencies
  # that are not available in the Nix build sandbox
  doCheck = false;

  meta = {
    description = "High performance in-memory column-oriented graph database engine";
    longDescription = ''
      TuringDB is a high-performance in-memory column-oriented graph database engine
      designed for analytical and read-intensive workloads. Built from scratch in C++,
      it delivers millisecond query latency on graphs with millions of nodes and edges.

      Key features:
      - 0.1-50ms query latency for analytical queries on 10M+ node graphs
      - Zero-lock concurrency model
      - Git-like versioning system for graphs
      - OpenCypher query language support
      - Python SDK with comprehensive API
    '';
    homepage = "https://turingdb.ai";
    changelog = "https://github.com/turing-db/turingdb/releases";
    license = lib.licenses.bsl11;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "turingdb";
    maintainers = with lib.maintainers; [
      drupol
    ];
  };
})
