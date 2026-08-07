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

  inherit (stdenv.hostPlatform.extensions) sharedLibrary;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "usearch";
  version = "2.25.3";

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
    hash = "sha256-lk6cBUwu3+ud/43HSmDWVP2RhXtH8+KmWSuREPoKQ4s=";
  };

  postPatch = ''
    rm -r numkong
    # TODO: change numkong to provide a CMakeLists.txt file or pc config file, so that headers can be auto discovered
    ln -s ${numkong.src} numkong
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    jemalloc
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  postInstall = ''
    install {libusearch*,sqlite/libsqlite3}${sharedLibrary} -t $lib/lib/
  '';

  preFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --replace-needed libnumkong${sharedLibrary} $lib/lib/libnumkong${sharedLibrary} \
        --replace-needed libsqlite3${sharedLibrary} $lib/lib/libsqlite3${sharedLibrary} \
        --shrink-rpath $lib/lib/libusearch*
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id $lib/lib/libnumkong${sharedLibrary} $lib/lib/libnumkong${sharedLibrary}
      for f in $lib/lib/libusearch*${sharedLibrary}; do
        install_name_tool \
          -change @rpath/libnumkong${sharedLibrary} $lib/lib/libnumkong${sharedLibrary} \
          "$f"
      done
    '';

  cmakeFlags = [
    # dependencies
    (lib.cmakeBool "USEARCH_USE_JEMALLOC" true)
    (lib.cmakeBool "USEARCH_USE_NUMKONG" true)
    (lib.cmakeBool "USEARCH_USE_OPENMP" true)

    # libraries
    (lib.cmakeBool "USEARCH_BUILD_LIB_C" true)
    (lib.cmakeBool "USEARCH_BUILD_SQLITE" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SQLITE3" sqliteSrc.outPath)

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
