{ stdenv, version, fetch, cmake, libcxx, fetchpatch }:

stdenv.mkDerivation {
  name = "libunwind-${version}";

  src = fetch "libunwind" "0q7ndlldid9wchnny0a936llwxj7zgb9gxp46wjjxvwwkik3l97z";

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

  enableParallelBuilding = true;
}
