{ lib, stdenv, llvm_meta, version, fetch, cmake, fetchpatch
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "0vhgcgzsb33l83qaikrkj87ypqb48mi607rccczccwiiv8ficw0q";

  patches = [
    (fetchpatch {
      url = "https://github.com/llvm-mirror/libunwind/commit/34a45c630d4c79af403661d267db42fbe7de1178.patch";
      sha256 = "0n0pv6jvcky8pn3srhrf9x5kbnd0d2kia9xlx2g590f5q0bgwfhv";
    })
    (fetchpatch {
      url = "https://github.com/llvm-mirror/libunwind/commit/e050272d2eb57eb4e56a37b429a61df2ebb8aa3e.patch";
      sha256 = "1sxyx5xnax8k713jjcxgq3jq3cpnxygs2rcdf5vfja0f2k9jzldl";
    })
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
