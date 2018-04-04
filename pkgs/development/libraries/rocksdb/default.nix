{ stdenv
, fetchFromGitHub
, fixDarwinDylibNames
, which, perl

# Optional Arguments
, snappy ? null, google-gflags ? null, zlib ? null, bzip2 ? null, lz4 ? null
, numactl ? null

# Malloc implementation
, jemalloc ? null, gperftools ? null

, enableLite ? false
}:

let
  malloc = if jemalloc != null then jemalloc else gperftools;
in
stdenv.mkDerivation rec {
  name = "rocksdb-${version}";
  version = "5.10.3";

  outputs = [ "dev" "out" "static" ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "rocksdb";
    rev = "v${version}";
    sha256 = "19d8i8map8qz639mhflmxc0w9gp78fvkq1l46y5s6b5imwh0w7xq";
  };

  nativeBuildInputs = [ which perl ];
  buildInputs = [ snappy google-gflags zlib bzip2 lz4 malloc fixDarwinDylibNames ];

  postPatch = ''
    # Hack to fix typos
    sed -i 's,#inlcude,#include,g' build_tools/build_detect_platform
  '';

  # Environment vars used for building certain configurations
  PORTABLE = "1";
  USE_SSE = "1";
  CMAKE_CXX_FLAGS = "-std=gnu++11";
  JEMALLOC_LIB = stdenv.lib.optionalString (malloc == jemalloc) "-ljemalloc";

  LIBNAME = "librocksdb${stdenv.lib.optionalString enableLite "_lite"}";
  ${if enableLite then "CXXFLAGS" else null} = "-DROCKSDB_LITE=1";

  buildAndInstallFlags = [
    "USE_RTTI=1"
    "DEBUG_LEVEL=0"
    "DISABLE_WARNING_AS_ERROR=1"
  ];

  buildFlags = buildAndInstallFlags ++ [
    "shared_lib"
    "static_lib"
  ];

  installFlags = buildAndInstallFlags ++ [
    "INSTALL_PATH=\${out}"
    "install-shared"
    "install-static"
  ];

  postInstall = ''
    # Might eventually remove this when we are confident in the build process
    echo "BUILD CONFIGURATION FOR SANITY CHECKING"
    cat make_config.mk
    mkdir -pv $static/lib/
    mv -vi $out/lib/${LIBNAME}.a $static/lib/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://rocksdb.org;
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ adev wkennington ];
  };
}
