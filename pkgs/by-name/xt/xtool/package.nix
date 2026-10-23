{
  lib,
  callPackage,
  coreutils,
  stdenv,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  fetchpatch,
  gnutar,
  makeWrapper,
  swift,
  swiftpm,
  pkg-config,
  libimobiledevice,
  libimobiledevice-glue,
  libplist,
  libusbmuxd,
  linkFarm,
  llvmPackages,
  open-apple-macros,
  openssl,
  unzip,
  versionCheckHook,
  xz,
  zip,
  zlib,
}:

let
  # same layout as the darwin-tools-linux-llvm release
  toolset = linkFarm "xtool-toolset" {
    "bin/ld64.lld" = lib.getExe' llvmPackages.lld "ld64.lld";
    "bin/libtool" = lib.getExe' llvmPackages.llvm "llvm-libtool-darwin";
    "bin/dsymutil" = lib.getExe' llvmPackages.llvm "dsymutil";
  };

  # same layout as the OpenAppleMacros release
  openAppleMacros = linkFarm "xtool-open-apple-macros" {
    "info.json" = "${open-apple-macros}/share/open-apple-macros/info.json";
    OpenAppleMacrosServer = "${open-apple-macros}/libexec/swift/plugins/OpenAppleMacrosServer";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xtool";
  version = "1.23.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "xtool-org";
    repo = "xtool";
    tag = finalAttrs.version;
    hash = "sha256-dfRgC0mfghSjNcZCBHxxuFmilKuYLPTf3yE0sZrjpWg=";
  };

  patches = [
    # TODO: https://github.com/xtool-org/xtool/pull/381
    (fetchpatch {
      name = "bump-dependencies.patch";
      url = "https://github.com/xtool-org/xtool/commit/845ec6513968d7d5073e930042140e4c1ca6ce4f.patch";
      hash = "sha256-pk5UC3BiBVa+ncoddF8HnsL7lX7gVt6GhG0PFuH9M1I=";
    })
    # TODO: https://github.com/xtool-org/xtool/pull/385
    (fetchpatch {
      name = "sdk-directory-overrides.patch";
      url = "https://github.com/xtool-org/xtool/commit/f1eca85cf4fe9806944fd68d75694acc32442c05.patch";
      hash = "sha256-AuO1JPecJZ5US+N7w/7s3+Z/RKjGtQPj2QfepqAMEp8=";
    })
    # TODO: https://github.com/xtool-org/xtool/pull/390
    (fetchpatch {
      name = "builder-edited-deps.patch";
      url = "https://github.com/xtool-org/xtool/commit/7f7d5b7e44dd023994dc4a8dbd55234c1c5dcee8.patch";
      hash = "sha256-dTA9bXtogOf9r1TZagUUST/A8jdtj19c54hdIjL1fOM=";
    })
    ./sdk-version-overrides.patch
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-8T66nOMEl+agG8dJ2gU7o83sKkyexTMg0qeMR/q9ZS0=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    swift
    swiftpm
  ];

  buildInputs = [
    libimobiledevice
    libimobiledevice-glue
    libplist
    libusbmuxd
    openssl
    xz
    zlib
  ];

  env = {
    XTOOL_VERSION = finalAttrs.version;
    # use the nixpkgs libraries instead of downloading prebuilt xcframeworks
    XTL_SYSTEM_LIBRARIES = "1";
  };

  # swift test needs Xcode's XCTest on macOS
  doCheck = !stdenv.hostPlatform.isDarwin;

  makeWrapperArgs = [
    # commands xtool runs from PATH
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      coreutils
      gnutar
      unzip
      zip
    ])
  ]
  # build the Darwin SDK with nixpkgs' tools instead of downloaded binaries
  # Xcode provides the SDK on macOS
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--set-default"
    "XTL_TOOLSET_TARBALL"
    toolset
    "--set-default"
    "XTL_OAM_TARBALL"
    openAppleMacros
  ];

  postInstall = ''
    wrapProgram "$out/bin/xtool" "''${makeWrapperArgs[@]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    sdk = callPackage ./sdk.nix { xtool = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Cross-platform Xcode replacement";
    homepage = "https://xtool.sh";
    changelog = "https://github.com/xtool-org/xtool/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "xtool";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ]
    ++ lib.platforms.darwin;
  };
})
