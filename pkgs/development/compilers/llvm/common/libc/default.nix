{
  lib,
  stdenv,
  llvm_meta,
  src ? null,
  monorepoSrc ? null,
  version,
  release_version,
  fetchpatch,
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

  src' =
    runCommand "${pname}-src-${version}"
      {
        strictDeps = true;
        __structuredAttrs = true;
      }
      (
        ''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"
          cp -r ${monorepoSrc}/runtimes "$out"
          cp -r ${monorepoSrc}/llvm "$out"
          cp -r ${monorepoSrc}/compiler-rt "$out"
          cp -r ${monorepoSrc}/${pname} "$out"
        ''
        + lib.optionalString (lib.versionAtLeast release_version "21") ''
          cp -r ${monorepoSrc}/third-party "$out"
        ''
      );

  needHdrGen = isFullBuild || lib.versionAtLeast release_version "22";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = src';

  sourceRoot = "${finalAttrs.src.name}/runtimes";

  # Linux removed `linux/scc.h`, which breaks building compiler-rt. Upstream LLVM has fixed it in LLVM 22 and 23.
  patches =
    patches
    ++ lib.optional (lib.strings.versionOlder version "22.1.5") (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/3dc4fd6dd41100f051a63642f449b16324389c96.patch?full_index=1";
      hash = "sha256-BJwFPeYCBO+PnUMMC/3GSYPgn0vczkkbdw5qcnURPbI=";
    });

  nativeBuildInputs = [
    cmake
    python3
    ninja
  ]
  ++ (lib.optional needHdrGen python3Packages.pyyaml);

  buildInputs = lib.optional (isFullBuild && stdenv.hostPlatform.isLinux) linuxHeaders;

  strictDeps = true;

  outputs = [ "out" ] ++ (lib.optional isFullBuild "dev");

  postUnpack = lib.optionalString needHdrGen ''
    chmod +w $sourceRoot/../$pname/utils/hdrgen
    patchShebangs $sourceRoot/../$pname/utils/hdrgen/main.py
    chmod +x $sourceRoot/../$pname/utils/hdrgen/main.py
  '';

  prePatch = ''
    cd ../${finalAttrs.pname}
    chmod -R u+w ../
    cd ..
  '';

  postPatch = ''
    cd runtimes
  '';

  postInstall =
    lib.optionalString (!isFullBuild) ''
      substitute ${./libc-shim.tpl} $out/lib/libc.so \
        --replace-fail "@out@" "$out" \
        --replace-fail "@libc@" "${stdenv.cc.libc}"
    ''
    # LLVM libc doesn't recognize static vs dynamic yet.
    # Treat LLVM libc as a static libc, requires this symlink until upstream fixes it.
    + lib.optionalString (isFullBuild && stdenv.hostPlatform.isLinux) ''
      ln $out/lib/crt1.o $out/lib/Scrt1.o
    '';

  cmakeFlags = [
    (lib.cmakeBool "LLVM_LIBC_FULL_BUILD" isFullBuild)
    (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "libc;compiler-rt")
    # Tests requires the host to have a libc.
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" (stdenv.cc.libc != null))
  ]
  ++ lib.optionals (isFullBuild && stdenv.cc.libc == null) [
    # CMake runs a check to see if the compiler works.
    # This includes including headers which requires a libc.
    # Skip these checks because a libc cannot be used when one doesn't exist.
    (lib.cmakeBool "CMAKE_C_COMPILER_WORKS" true)
    (lib.cmakeBool "CMAKE_CXX_COMPILER_WORKS" true)
  ];

  # For the update script:
  passthru = {
    monorepoSrc = monorepoSrc;
    inherit isFullBuild;
  };

  __structuredAttrs = true;

  meta = llvm_meta // {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://libc.llvm.org/";
    description = "Standard C library for LLVM";
  };
})
