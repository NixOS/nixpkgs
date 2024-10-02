{
  lib,
  stdenv,
  llvm_meta,
  monorepoSrc,
  runCommand,
  cmake,
  libxml2,
  libllvm,
  libclang,
  version,
  python3,
  buildLlvmTools,
  patches ? [ ],
  devExtraCmakeFlags ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bolt";
  inherit version patches;

  # Blank llvm dir just so relative path works
  src = runCommand "bolt-src-${finalAttrs.version}" { } ''
    mkdir $out
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${finalAttrs.pname} "$out"
    cp -r ${monorepoSrc}/third-party "$out"

    # tablegen stuff, probably not the best way but it works...
    cp -r ${monorepoSrc}/llvm/ "$out"
    chmod -R +w $out/llvm
  '';

  sourceRoot = "${finalAttrs.src.name}/bolt";

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    libllvm
    libclang
    libxml2
  ];

  cmakeFlags =
    lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmTools.llvm}/bin/llvm-tblgen")
    ]
    ++ devExtraCmakeFlags;

  postUnpack = ''
    chmod -R u+w -- $sourceRoot/..
  '';

  prePatch = ''
    cd ..
  '';

  postPatch = ''
    cd bolt
  '';

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/libLLVMBOLT*.a $dev/lib
  '';

  outputs = [
    "out"
    "dev"
  ];

  meta = llvm_meta // {
    homepage = "https://github.com/llvm/llvm-project/tree/main/bolt";
    description = "LLVM post-link optimizer.";
  };
})
