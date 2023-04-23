{ lib, stdenv, llvm_meta, version, fetch, fetchpatch, cmake, llvm
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "035dsxs10nyiqd00q07yycvmkjl01yz4jdlrjvmch8klxg4pyjhp";

  postUnpack = ''
    unpackFile ${llvm.src}
    cmakeFlagsArray=($cmakeFlagsArray -DLLVM_PATH=$PWD/$(ls -d llvm-*))
  '';

  patches = [
    ./gnu-install-dirs.patch
  ] ++ lib.optionals (stdenv.hostPlatform.useLLVM or false) [
    # removes use of `new` that require libc++
    (fetchpatch {
      url = "https://github.com/llvm-mirror/libunwind/commit/34a45c630d4c79af403661d267db42fbe7de1178.patch";
      sha256 = "0n0pv6jvcky8pn3srhrf9x5kbnd0d2kia9xlx2g590f5q0bgwfhv";
    })
    # cleans up remaining libc++ dependencies (mostly header inclusions)
    (fetchpatch {
      url = "https://github.com/llvm-mirror/libunwind/commit/e050272d2eb57eb4e56a37b429a61df2ebb8aa3e.patch";
      sha256 = "170mwmj0wf40iyk1kzdpaiy36rz9n8dpl881h4h7s5da0rh51xya";
      includes = [ "src/libunwind.cpp" "src/UnwindCursor.hpp" ];
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals (!enableShared) [
    "-DLIBUNWIND_ENABLE_SHARED=OFF"
  ] ++ lib.optionals (stdenv.hostPlatform.useLLVM or false) [
    "-DLLVM_ENABLE_LIBCXX=ON"
  ];

  meta = llvm_meta // {
    # Details: https://github.com/llvm/llvm-project/blob/main/libunwind/docs/index.rst
    homepage = "https://clang.llvm.org/docs/Toolchain.html#unwind-library";
    description = "LLVM's unwinder library";
    longDescription = ''
      The unwind library provides a family of _Unwind_* functions implementing
      the language-neutral stack unwinding portion of the Itanium C++ ABI (Level
      I). It is a dependency of the C++ ABI library, and sometimes is a
      dependency of other runtimes.
    '';
  };
}
