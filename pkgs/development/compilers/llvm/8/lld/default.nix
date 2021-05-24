{ lib, stdenv
, buildLlvmTools
, fetch
, cmake
, libxml2
, libllvm
, version
}:

stdenv.mkDerivation {
  pname = "lld";
  inherit version;

  src = fetch "lld" "121xhxrlvwy3k5nf6p1wv31whxlb635ssfkci8z93mwv4ja1xflz";

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm libxml2 ];

  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${libllvm.dev}/bin/llvm-config${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-native"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
  ];

  outputs = [ "out" "lib" "dev" ];

  meta = {
    description = "The LLVM Linker";
    homepage    = "https://lld.llvm.org/";
    license     = lib.licenses.ncsa;
    platforms   = lib.platforms.all;
  };
}
