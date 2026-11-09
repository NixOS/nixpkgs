{
  lib,
  cmake,
  fetchFromGitHub,
  indexstore-db,
  ninja,
  stdenv,
  swift,
  swift-argument-parser,
  swift-asn1,
  swift-collections,
  swift-corelibs-foundation,
  swift-corelibs-libdispatch,
  swift-crypto,
  swift-foundation,
  swift-foundation-icu,
  swift-llbuild,
  swift-lmdb,
  swift-syntax,
  swift-tools-protocols,
  swift-tools-support-core,
  swiftpm,
  versionCheckHook,
  swift_release,
  swift_sources,
}:

let
  rpaths = [
    indexstore-db
    swift-argument-parser
    swift-asn1
    swift-collections
    swift-crypto
    swift-llbuild
    swift-lmdb
    swift-syntax-no-toolchain
    swift-tools-protocols
    swift-tools-support-core
    swiftpm
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    swift-corelibs-foundation
    swift-corelibs-libdispatch
    swift-foundation
    swift-foundation-icu
  ];

  swift-syntax-no-toolchain = swift-syntax.override { useToolchainLibraries = false; };

  swift' = swift.override {
    enableRepl = false;
    enableSourceKitLSP = false;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sourcekit-lsp";
  version = swift_release;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "sourcekit-lsp";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.sourcekit-lsp) hash;
  };

  patches = [
    # We can’t use the XCTest framework on Darwin and have to use swift-corelibs-xctest. Patch the `PerfTestCase`
    # base class to build with it on Darwin.
    ./patches/0001-Fix-for-using-swift-corelibs-xctest-on-Darwin.patch
    # A couple of required libraries are missing from the `CMakeLists.txt` files.
    ./patches/0002-add-missing-libraries.patch
  ];

  postPatch =
    # Make the build complain loudly when a dependency is not available.
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail QUIET REQUIRED

      # Except for dispatch and Foundation, which are part of the SDK on Darwin.
      substituteInPlace CMakeLists.txt \
        --replace-fail 'dispatch REQUIRED' 'dispatch QUIET' \
        --replace-fail 'Foundation REQUIRED' 'Foundation QUIET'
    '';

  strictDeps = true;

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift'
  ];

  buildInputs = [
    indexstore-db
    swift-argument-parser
    swift-asn1
    swift-collections
    swift-crypto
    swift-llbuild
    swift-lmdb
    swift-syntax-no-toolchain
    swift-tools-protocols
    swift-tools-support-core
    swiftpm
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    swift-corelibs-foundation
    swift-corelibs-libdispatch
    swift-foundation
    swift-foundation-icu
  ];

  # Tests crash with `*** bit out of range 0 - FD_SETSIZE on fd_set ***: terminated`
  doCheck = false; # !stdenv.hostPlatform.isDarwin;

  postInstall =
    # Add missing rpaths.
    lib.optionalString stdenv.hostPlatform.isElf ''
      for output in "''${outputs[@]}"; do
        while IFS= read -d "" f; do
          if isELF "$f"; then
            patchelf --add-rpath ${lib.escapeShellArg (lib.makeLibraryPath rpaths)} "$f"
          fi
        done < <(find "$output" -type f -print0)
      done
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--help";
  preVersionCheck = "version='OVERVIEW: Language Server Protocol implementation'";

  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Language Server Protocol implementation for Swift and C-based languages";
    mainProgram = "sourcekit-lsp";
    homepage = "https://github.com/apple/sourcekit-lsp";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
