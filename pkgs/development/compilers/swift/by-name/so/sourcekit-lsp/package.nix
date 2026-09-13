{
  lib,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  llvmPackages,
  ncurses,
  pkg-config,
  replaceVars,
  sqlite,
  stdenv,
  swift,
  swift-corelibs-libdispatch,
  swiftpm,
  swift_release,
  swift_sources,
}:

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
    # SourceKit-LSP tries to load IndexStore from the toolchain, but we want to load it from the store directly instead.
    (replaceVars ./patches/0002-Load-IndexStore-from-the-store.patch {
      libclang = lib.getLib llvmPackages.libclang;
    })
  ];

  # The SwiftPM patches can’t be included in the swiftpmDeps FOD because they reference store paths.
  swiftpmPatches = swiftpm.patches;

  postPatch = ''
    packagesPath=$(readlink -f Packages)

    rm Packages
    cp -r "$packagesPath" Packages
    chmod -R u+w Packages/swift-package-manager

    for p in "''${swiftpmPatches[@]}"; do
      # Don’t apply the backdeploy patch because it creates a link to the Swift toolchain,
      # which bloats up the SourceKit-LSP closure quite significantly.
      if ! [[ $p =~ fix-backdeploy-rpath\.patch ]]; then
        echo "applying patch $p"
        patch -d Packages/swift-package-manager -p1 < "$p"
      fi
    done
  '';

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xpvXcm2qtCd2xhClbR6BLwmaupSHg1H25uJd7Thgd/4=";

    # Upstream doesn’t provide `Package.resolved`.
    postPatch = ''
      # Upstream doesn’t provide `Package.resolved`.
      ln -s ${./Package.resolved} Package.resolved
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    swift
    swiftpm
  ];

  buildInputs = [
    ncurses
    sqlite
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ swift-corelibs-libdispatch ];

  # Tests crash with `*** bit out of range 0 - FD_SETSIZE on fd_set ***: terminated`
  doCheck = false; # !stdenv.hostPlatform.isDarwin;

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
