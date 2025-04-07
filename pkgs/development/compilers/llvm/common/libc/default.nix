{
  lib,
  stdenv,
  llvm_meta,
  src ? null,
  monorepoSrc ? null,
  version,
  release_version,
  runCommand,
  python3,
  python3Packages,
  patches ? [ ],
  cmake,
  ninja,
  isFullBuild ? true,
  linuxHeaders,
}:
let
  pname = "libc";

  src' = runCommand "${pname}-src-${version}" { } (''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/runtimes "$out"
    cp -r ${monorepoSrc}/llvm "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
  '');
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version patches;

  src = src';

  sourceRoot = "${finalAttrs.src.name}/runtimes";

  nativeBuildInputs =
    [
      cmake
      python3
    ]
    ++ (lib.optional (lib.versionAtLeast release_version "15") ninja)
    ++ (lib.optional isFullBuild python3Packages.pyyaml);

  buildInputs = lib.optional isFullBuild linuxHeaders;

  outputs = [ "out" ] ++ (lib.optional isFullBuild "dev");

  postUnpack = lib.optionalString isFullBuild ''
    patchShebangs $sourceRoot/../$pname/utils/hdrgen/main.py
    chmod +x $sourceRoot/../$pname/utils/hdrgen/main.py
  '';

  prePatch = ''
    cd ../${finalAttrs.pname}
    chmod -R u+w ../
  '';

  postPatch = ''
    cd ../runtimes
  '';

  postInstall = lib.optionalString (!isFullBuild) ''
    substituteAll ${./libc-shim.tpl} $out/lib/libc.so
  '';

  libc = if (!isFullBuild) then stdenv.cc.libc else null;

  cmakeFlags = [
    (lib.cmakeBool "LLVM_LIBC_FULL_BUILD" isFullBuild)
    (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "libc")
  ];

  # For the update script:
  passthru = {
    monorepoSrc = monorepoSrc;
    inherit isFullBuild;
  };

  meta = llvm_meta // {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://libc.llvm.org/";
    description = "Standard C library for LLVM";
  };
})
