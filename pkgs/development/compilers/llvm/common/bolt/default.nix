{
  lib,
  stdenv,
  llvm_meta,
  monorepoSrc,
  release_version,
  runCommand,
  cmake,
  libxml2,
  libllvm,
  ninja,
  libclang,
  version,
  python3,
  substituteAll,
  buildLlvmTools,
  patches ? [ ],
  devExtraCmakeFlags ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bolt";
  inherit version patches;

  # Blank llvm dir just so relative path works
  src = runCommand "bolt-src-${finalAttrs.version}" { inherit (monorepoSrc) passthru; } (
    ''
      mkdir $out
    ''
    + lib.optionalString (lib.versionAtLeast release_version "14") ''
      cp -r ${monorepoSrc}/cmake "$out"
    ''
    + ''
      cp -r ${monorepoSrc}/${finalAttrs.pname} "$out"
      cp -r ${monorepoSrc}/third-party "$out"

      # BOLT re-runs tablegen against LLVM sources, so needs them available.
      cp -r ${monorepoSrc}/llvm/ "$out"
      chmod -R +w $out/llvm
    ''
  );

  sourceRoot = "${finalAttrs.src.name}/bolt";

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    libllvm
    libxml2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/llvm-tblgen")
  ] ++ devExtraCmakeFlags;

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

    mkdir -p $out/nix-support
    cp $setupHook $out/nix-support/setup-hook
  '';

  outputs = [
    "out"
    "dev"
  ];

  setupHook = substituteAll {
    src = ./setup-hook.sh.in;
    env.readelf = lib.getExe' libllvm "llvm-readelf";
  };

  meta = llvm_meta // {
    homepage = "https://github.com/llvm/llvm-project/tree/main/bolt";
    description = "LLVM post-link optimizer.";
  };
})
