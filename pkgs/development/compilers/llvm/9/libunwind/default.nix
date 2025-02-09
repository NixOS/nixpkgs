{ lib, stdenv, llvm_meta, version, fetch, cmake, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "1wb02ha3gl6p0a321hwpll74pz5qvjr11xmjqx62g288f1m10njk";

  patches = [
    ./gnu-install-dirs.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";

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
