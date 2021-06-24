{ lib, stdenv, version, fetch, cmake, fetchpatch
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libunwind";
  inherit version;

  src = fetch "libunwind" "0vhgcgzsb33l83qaikrkj87ypqb48mi607rccczccwiiv8ficw0q";

  nativeBuildInputs = [ cmake ];

  patches = [
    (fetchpatch {
      url = "https://github.com/llvm-mirror/libunwind/commit/34a45c630d4c79af403661d267db42fbe7de1178.patch";
      sha256 = "0n0pv6jvcky8pn3srhrf9x5kbnd0d2kia9xlx2g590f5q0bgwfhv";
    })
    (fetchpatch {
      url = "https://github.com/llvm-mirror/libunwind/commit/e050272d2eb57eb4e56a37b429a61df2ebb8aa3e.patch";
      sha256 = "1sxyx5xnax8k713jjcxgq3jq3cpnxygs2rcdf5vfja0f2k9jzldl";
    })
  ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
