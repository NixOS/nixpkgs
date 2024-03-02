{ lib, stdenv , llvm_meta
, monorepoSrc , runCommand
, cmake, libxml2, libllvm, libclang, version, python3
, buildLlvmTools
, additionalPatches ? []
}:

stdenv.mkDerivation rec {
  pname = "bolt";
  inherit version;

  # Blank llvm dir just so relative path works
  src = runCommand "bolt-src-${version}" { } ''
    mkdir $out
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
    cp -r ${monorepoSrc}/third-party "$out"

    # tablegen stuff, probably not the best way but it works...
    cp -r ${monorepoSrc}/llvm/ "$out"
    chmod -R +w $out/llvm
    patch $out/llvm/lib/Target/RISCV/MCTargetDesc/RISCVMCTargetDesc.h < ${./riscv.patch}
  '';

  sourceRoot = "${src.name}/bolt";

  nativeBuildInputs = [ cmake python3 ];

  buildInputs = [ libllvm libclang libxml2 ];

  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
  ];

  patches = additionalPatches ++ [ ./cmake.patch ];

  outputs = [ "out" "lib" ];

  meta = llvm_meta // {
    # the patch does not work for older version
    broken = lib.versionOlder version "17.0.0";
    homepage = "https://github.com/llvm/llvm-project/tree/main/bolt";
    description = "LLVM post-link optimizer.";
  };
}
