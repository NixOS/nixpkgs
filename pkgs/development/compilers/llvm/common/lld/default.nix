{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  buildLlvmTools,
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
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lld";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "lld-src-${version}" { inherit (monorepoSrc) passthru; } (
        ''
          mkdir -p "$out"
        ''
        + lib.optionalString (lib.versionAtLeast release_version "14") ''
          cp -r ${monorepoSrc}/cmake "$out"
        ''
        + ''
          cp -r ${monorepoSrc}/lld "$out"
          mkdir -p "$out/libunwind"
          cp -r ${monorepoSrc}/libunwind/include "$out/libunwind"
          mkdir -p "$out/llvm"
        ''
      )
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/lld";

  patches = [
    (getVersionFile "lld/gnu-install-dirs.patch")
  ]
  ++ lib.optional (lib.versions.major release_version == "14") (
    getVersionFile "lld/fix-root-src-dir.patch"
  )
  ++ lib.optional (lib.versionAtLeast release_version "16" && lib.versionOlder release_version "18") (
    getVersionFile "lld/add-table-base.patch"
  )
  ++ lib.optional (lib.versions.major release_version == "18") (
    # https://github.com/llvm/llvm-project/pull/97122
    fetchpatch {
      name = "more-openbsd-program-headers.patch";
      url = "https://github.com/llvm/llvm-project/commit/d7fd8b19e560fbb613159625acd8046d0df75115.patch";
      stripLen = 1;
      hash = "sha256-7wTy7XDTx0+fhWQpW1KEuz7xJvpl42qMTUfd20KGOfA=";
    }
  );

  nativeBuildInputs = [ cmake ] ++ lib.optional (lib.versionAtLeast release_version "15") ninja;
  buildInputs = [
    libllvm
    libxml2
  ];

  cmakeFlags =
    lib.optionals (lib.versionOlder release_version "14") [
      (lib.cmakeFeature "LLVM_CONFIG_PATH" "${libllvm.dev}/bin/llvm-config${
        lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-native"
      }")
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "15") [
      (lib.cmakeFeature "LLD_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/lld")
    ]
    ++ [
      (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/llvm-tblgen")
    ]
    ++ devExtraCmakeFlags;

  postPatch = lib.optionalString (lib.versionOlder release_version "14") ''
    substituteInPlace MachO/CMakeLists.txt --replace-fail \
      '(''${LLVM_MAIN_SRC_DIR}/' '(../'
  '';

  # Musl's default stack size is too small for lld to be able to link Firefox.
  LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-Wl,-z,stack-size=2097152";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

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
