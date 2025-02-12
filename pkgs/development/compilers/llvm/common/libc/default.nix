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
  fetchpatch,
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
  inherit pname version;

  src = src';

  sourceRoot = "${finalAttrs.src.name}/runtimes";

  patches =
    lib.optional (lib.versions.major version == "20")
      # Removes invalid token from the LLVM version being placed in the namespace.
      # Can be removed when LLVM 20 bumps to rc2.
      # PR: https://github.com/llvm/llvm-project/pull/126284
      (
        fetchpatch {
          url = "https://github.com/llvm/llvm-project/commit/3a3a3230d171e11842a9940b6da0f72022b1c5b3.patch";
          stripLen = 1;
          hash = "sha256-QiU1cWp+027ZZNVdvfGVwbIoRd9jqtSbftGsmaW1gig=";
        }
      )
    ++ patches;

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
    substituteAll ${./libc-shim.so} $out/lib/libc.so
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
    homepage = "https://libc.llvm.org/";
    description = "Standard C library for LLVM";
  };
})
