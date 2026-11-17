{
  lib,
  cmake,
  fetchFromGitHub,
  fetchzip,
  jemalloc,
  llvmPackages,
  numkong,
  stdenv,
}:
let
  sqliteSrc = fetchzip {
    url = "https://sqlite.org/2024/sqlite-amalgamation-3450200.zip";
    hash = "sha256-nkDMIiTHjeiopPbGcviQekgSOYifuNM/kr07IHgQvoI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "usearch";
  version = "2.26.6";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "unum-cloud";
    repo = "USearch";
    tag = "v${finalAttrs.version}";
    # we need to use the pinned stringzilla because the now removed (or partially by levenshtein replaced) hamming_distance is being used.
    fetchSubmodules = true;
    hash = "sha256-NRYMJF8iexxAKDfcDgbDOF3G8dOMvedp4C8HydbYJRE=";
  };

  postPatch = ''
    rm -r numkong
    # TODO: change numkong to provide a CMakeLists.txt file or pc config file, so that headers can be auto discovered
    ln -s ${numkong.src} numkong

    # Allow us to change those variables
    substituteInPlace CMakeLists.txt \
      --replace-fail '    CACHE INTERNAL ""' '    CACHE PATH ""' \
      --replace-fail 'set(USEARCH_PKGCONFIG_INSTALL_DIR "''${CMAKE_INSTALL_DATADIR}/pkgconfig")' \
                     'set(USEARCH_PKGCONFIG_INSTALL_DIR "''${CMAKE_INSTALL_DATADIR}/pkgconfig" CACHE PATH "")'

    # Install sqlite shared objects used by the python package
    substituteInPlace sqlite/CMakeLists.txt \
      --replace-fail '    setup_target(usearch_sqlite)' '    setup_target(usearch_sqlite)
    install(TARGETS usearch_sqlite sqlite3_shared LIBRARY DESTINATION "''${CMAKE_INSTALL_LIBDIR}")'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    jemalloc
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  cmakeFlags = [
    # dependencies
    (lib.cmakeBool "USEARCH_USE_JEMALLOC" true)
    (lib.cmakeBool "USEARCH_USE_NUMKONG" true)
    (lib.cmakeBool "USEARCH_USE_OPENMP" true)

    # libraries
    (lib.cmakeBool "USEARCH_BUILD_LIB_C" true)
    (lib.cmakeBool "USEARCH_BUILD_SQLITE" true)
    (lib.cmakeBool "USEARCH_INSTALL" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SQLITE3" sqliteSrc.outPath)
    (lib.cmakeFeature "USEARCH_CONFIG_INSTALL_DIR" "${placeholder "dev"}/lib/cmake/usearch")
    (lib.cmakeFeature "USEARCH_PKGCONFIG_INSTALL_DIR" "${placeholder "dev"}/lib/pkgconfig")

    # checks
    (lib.cmakeBool "USEARCH_BUILD_TEST_C" true)
    (lib.cmakeBool "USEARCH_BUILD_TEST_CPP" true)

    # benchmarking not only wastes CPU, but also requires the clipp repo to be cloned
    (lib.cmakeBool "USEARCH_BUILD_BENCH_CPP" false)
  ];

  meta = {
    description = "Smaller & Faster Single-File Vector Search Engine from Unum";
    homepage = "https://github.com/unum-cloud/USearch/";
    changelog = "https://github.com/unum-cloud/USearch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
