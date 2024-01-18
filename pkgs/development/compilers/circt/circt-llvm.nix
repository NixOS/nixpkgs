{ stdenv
, cmake
, ninja
, circt
, llvm
, python3
}: stdenv.mkDerivation {
  pname = circt.pname + "-llvm";
  inherit (circt) version src;

  requiredSystemFeatures = [ "big-parallel" ];

  nativeBuildInputs = [ cmake ninja python3 ];

  preConfigure = ''
    cd llvm/llvm
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DLLVM_ENABLE_BINDINGS=OFF"
    "-DLLVM_ENABLE_OCAMLDOC=OFF"
    "-DLLVM_BUILD_EXAMPLES=OFF"
    "-DLLVM_OPTIMIZED_TABLEGEN=ON"
    "-DLLVM_ENABLE_PROJECTS=mlir"
    "-DLLVM_TARGETS_TO_BUILD="

    # This option is needed to install llvm-config
    "-DLLVM_INSTALL_UTILS=ON"
  ];

  outputs = [ "out" "lib" "dev" ];

  postInstall = ''
    # move llvm-config to $dev to resolve a circular dependency
    moveToOutput "bin/llvm-config*" "$dev"

    # move all lib files to $lib except lib/cmake
    moveToOutput "lib" "$lib"
    moveToOutput "lib/cmake" "$dev"

    # patch configuration files so each path points to the new $lib or $dev paths
    substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
      --replace 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
    substituteInPlace \
      "$dev/lib/cmake/llvm/LLVMExports-release.cmake" \
      "$dev/lib/cmake/mlir/MLIRTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$lib/lib/lib" \
      --replace "\''${_IMPORT_PREFIX}/lib/objects-Release" "$lib/lib/objects-Release" \
      --replace "$out/bin/llvm-config" "$dev/bin/llvm-config" # patch path for llvm-config
  '';

  doCheck = true;
  checkTarget = "check-mlir";

  meta = llvm.meta // {
    inherit (circt.meta) maintainers;
  };
}
