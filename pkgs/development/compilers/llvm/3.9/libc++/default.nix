{ lib, stdenv, fetch, cmake, libcxxabi, fixDarwinDylibNames, version }:

stdenv.mkDerivation rec {
  pname = "libc++";
  inherit version;

  src = fetch "libcxx" "0qbl3afl2p2h87p977lsqr5kykl6cgjpkzczs0g6a3pn53j1bri5";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
  '';

  preConfigure = ''
    # Get headers from the cxxabi source so we can see private headers not installed by the cxxabi package
    cmakeFlagsArray=($cmakeFlagsArray -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$NIX_BUILD_TOP/libcxxabi-${version}.src/include")
  '';

  patches = [
    # glibc 2.26 fix
    ./xlocale-glibc-2.26.patch
  ]
  ++ lib.optional stdenv.isDarwin ./darwin.patch
  ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    ../../libcxx-0001-musl-hacks.patch
    ../../libcxx-max_align_t.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libcxxabi ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags = [
    "-DLIBCXX_LIBCXXABI_LIB_PATH=${libcxxabi}/lib"
    "-DLIBCXX_LIBCPPABI_VERSION=2"
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "-DLIBCXX_HAS_MUSL_LIBC=1";

  enableParallelBuilding = true;

  linkCxxAbi = stdenv.isLinux;

  setupHooks = [
    ../../../../../build-support/setup-hooks/role.bash
    ./setup-hook.sh
  ];

  meta = {
    homepage = http://libcxx.llvm.org/;
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = with stdenv.lib.licenses; [ ncsa mit ];
    platforms = stdenv.lib.platforms.unix;
  };
}
