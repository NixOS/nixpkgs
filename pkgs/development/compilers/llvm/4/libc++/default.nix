{ lib, stdenv, fetch, cmake, python, libcxxabi, fixDarwinDylibNames, version }:

stdenv.mkDerivation rec {
  name = "libc++-${version}";

  src = fetch "libcxx" "0k6cmjcxnp2pyl8xwy1wkyyckkmdrjddim94yf1gzjbjy9qi22jj";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    export LIBCXXABI_INCLUDE_DIR="$PWD/$(ls -d libcxxabi-${version}*)/include"
  '';

  patches = [
    # https://github.com/llvm-mirror/libcxx/commit/bcc92d75df0274b9593ebd097fcae60494e3bffc
    ./pthread_mach_thread_np.patch
    # glibc 2.26 fix
    ./xlocale-glibc-2.26.patch
  ] ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    ../../libcxx-0001-musl-hacks.patch
    ../../libcxx-max_align_t.patch
  ];

  prePatch = ''
    substituteInPlace lib/CMakeLists.txt --replace "/usr/lib/libc++" "\''${LIBCXX_LIBCXXABI_LIB_PATH}/libc++"
  '';

  preConfigure = ''
    # Get headers from the cxxabi source so we can see private headers not installed by the cxxabi package
    cmakeFlagsArray=($cmakeFlagsArray -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$LIBCXXABI_INCLUDE_DIR")
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';
  nativeBuildInputs = [ cmake ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl python;

  buildInputs = [ libcxxabi ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags = [
    "-DLIBCXX_LIBCXXABI_LIB_PATH=${libcxxabi}/lib"
    "-DLIBCXX_LIBCPPABI_VERSION=2"
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "-DLIBCXX_HAS_MUSL_LIBC=1";

  enableParallelBuilding = true;

  linkCxxAbi = stdenv.isLinux;

  postInstall = ''
    mv $out/lib/libc++.a $out/lib/libc++_static.a
    cp ${./libc++.a} $out/lib/libc++.a
  '';

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
