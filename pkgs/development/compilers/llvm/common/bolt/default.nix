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
  buildLlvmTools,
  patches ? [ ],
  devExtraCmakeFlags ? [ ],
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bolt";
  inherit version;

  # Blank llvm dir just so relative path works
  src = runCommand "bolt-src-${finalAttrs.version}" { inherit (monorepoSrc) passthru; } ''
    mkdir $out
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${finalAttrs.pname} "$out"
    cp -r ${monorepoSrc}/third-party "$out"

    # BOLT re-runs tablegen against LLVM sources, so needs them available.
    cp -r ${monorepoSrc}/llvm/ "$out"
    chmod -R +w $out/llvm
  '';

  sourceRoot = "${finalAttrs.src.name}/bolt";

  patches = lib.optionals (lib.versions.major release_version == "19") [
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/abc2eae68290c453e1899a94eccc4ed5ea3b69c1.patch";
      hash = "sha256-oxCxOjhi5BhNBEraWalEwa1rS3Mx9CuQgRVZ2hrbd7M=";
    })
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/5909979869edca359bcbca74042c2939d900680e.patch";
      hash = "sha256-l4rQHYbblEADBXaZIdqTG0sZzH4fEQvYiqhLYNZDMa8=";
    })
  ];

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
    description = "LLVM post-link optimizer";
  };
})
