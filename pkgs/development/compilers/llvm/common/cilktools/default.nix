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
  cheetah,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cilktools";
  inherit version;

  src = runCommand "cilktools-src-${version}" { } ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/cilktools "$out"
  '';

  sourceRoot = "${finalAttrs.src.name}/cilktools";

  nativeBuildInputs = [
    cmake
    python3
    libllvm.dev
    ninja
  ];

  buildInputs = [
    cheetah
  ];

  cmakeFlags = [
    "-DCILKTOOLS_INCLUDE_DIRS=${cheetah}/include"
  ];

  meta = llvm_meta // {
    homepage = "https://opencilk.org/";
    description = "OpenCilk Productivity Tools";
    license = lib.licenses.mit;
  };
})
