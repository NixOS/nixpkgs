{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  version,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  python3,
  libllvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cheetah";
  inherit version;

  src = runCommand "cheetah-src-${version}" { } ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/cheetah "$out"
  '';

  sourceRoot = "${finalAttrs.src.name}/cheetah";

  nativeBuildInputs = [
    cmake
    python3
    libllvm.dev
    ninja
  ];

  meta = llvm_meta // {
    homepage = "https://opencilk.org/";
    description = "OpenCilk Runtime (Cheetah)";
    license = lib.licenses.mit;
  };
})
