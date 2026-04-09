{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gitMinimal,
  bison,
  flex,
  inih,
  minio-cpp,
  curl,
  curlpp,
  nlohmann_json,
  openssl,
  openblas,
  pugixml,
  faiss,
  zlib,
  llvmPackages_20,
  versionCheckHook,
}:

let
  turingstdenv = if stdenv.isDarwin then llvmPackages_20.stdenv else stdenv;
in
turingstdenv.mkDerivation (finalAttrs: {
  pname = "turingdb";
  version = "1.28";

  src = fetchFromGitHub {
    owner = "turing-db";
    repo = "turingdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ILKcUPj/2pO30u39SlFkBwUSOy1zLA+MqFhQ/XMpLV8=";

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
    curl
    curlpp
    faiss
    inih
    minio-cpp
    nlohmann_json
    openblas
    openssl
    pugixml
    zlib
  ]
  ++ lib.optionals turingstdenv.isDarwin [ llvmPackages_20.openmp ]
  ++ lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  cmakeFlags = [
    (lib.cmakeBool "NIX_BUILD" true)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-fopenmp")
    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-lgomp")
    (lib.cmakeFeature "FLEX_INCLUDE_DIR" "${lib.getDev flex}/include")
  ]
  ++ lib.optionals stdenv.isDarwin [
    (lib.cmakeFeature "OpenMP_CXX_FLAGS" "-fopenmp")
    (lib.cmakeFeature "OpenMP_CXX_LIB_NAMES" "omp")
    (lib.cmakeFeature "OpenMP_omp_LIBRARY" "${lib.getLib llvmPackages_20.openmp}/lib/libomp.dylib")
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  # Upstream tests require running a TuringDB server and performing
  # network operations, which are incompatible with the Nix build sandbox.
  doCheck = false;

  meta = {
    description = "High performance in-memory column-oriented graph database engine";
    longDescription = ''
      TuringDB is a high-performance in-memory column-oriented graph
      database engine designed for analytical and read-intensive workloads.
    '';
    homepage = "https://turingdb.ai";
    changelog = "https://github.com/turing-db/turingdb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsl11;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "turingdb";
    maintainers = with lib.maintainers; [
      cyrusknopf
      drupol
      roquess
    ];
  };
})
