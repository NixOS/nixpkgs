{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  buildLlvmPackages,
  monorepoSrc ? null,
  src ? null,
  runCommand,
  cmake,
  ninja,
  libxml2,
  libllvm,
  version,
  devExtraCmakeFlags ? [ ],
  getVersionFile,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lld";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "lld-src-${version}"
        {
          inherit (monorepoSrc) passthru;
          strictDeps = true;
          __structuredAttrs = true;
        }
        ''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"
          cp -r ${monorepoSrc}/lld "$out"
          mkdir -p "$out/libunwind"
          cp -r ${monorepoSrc}/libunwind/include "$out/libunwind"
          mkdir -p "$out/llvm"
        ''
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/lld";

  patches = [
    (getVersionFile "lld/gnu-install-dirs.patch")
  ]
  # https://github.com/llvm/llvm-project/pull/198129, which is fixed in 22.1.8
  ++ lib.optionals (lib.versionOlder release_version "22") [
    (getVersionFile "lld/initialize-symbol-fields.patch")
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    libllvm
    libxml2
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeFeature "LLD_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/lld")
    (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmPackages.tblgen}/bin/llvm-tblgen")
  ]
  ++ devExtraCmakeFlags;

  # Musl's default stack size is too small for lld to be able to link Firefox.
  env = lib.optionalAttrs stdenv.hostPlatform.isMusl {
    LDFLAGS = "-Wl,-z,stack-size=2097152";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  __structuredAttrs = true;

  meta = llvm_meta // {
    homepage = "https://lld.llvm.org/";
    description = "LLVM linker (unwrapped)";
    longDescription = ''
      LLD is a linker from the LLVM project that is a drop-in replacement for
      system linkers and runs much faster than them. It also provides features
      that are useful for toolchain developers.
      The linker supports ELF (Unix), PE/COFF (Windows), Mach-O (macOS), and
      WebAssembly in descending order of completeness. Internally, LLD consists
      of several different linkers.
    '';
  };
})
