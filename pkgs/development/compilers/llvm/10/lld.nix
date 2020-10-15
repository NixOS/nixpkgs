{ stdenv
, buildPackages
, fetch
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch pname "0ynzi35r4fckvp6842alpd43qr810j3728yfslc66fk2mbh4j52r";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm libxml2 ];

  cmakeFlags = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildPackages.llvm_10}/bin/llvm-tblgen"
    "-DLLVM_CONFIG_PATH=${llvm}/bin/llvm-config-native"
  ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = "https://lld.llvm.org/";
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
