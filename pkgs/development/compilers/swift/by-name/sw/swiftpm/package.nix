{
  lib,
  callPackage,
  cmake,
  fetchFromGitHub,
  ninja,
  replaceVars,
  sqlite,
  stdenv,
  swift,
  swift-argument-parser,
  swift-asn1,
  swift-build,
  swift-certificates,
  swift-collections,
  swift-crypto,
  swift-driver,
  swift-llbuild,
  swift-syntax,
  swift-system,
  swift-tools-protocols,
  swift-tools-support-core,
  swiftpmHook,
  swift_release,
  swift_sources,
}:

let
  swift-syntax-no-toolchain = swift-syntax.override { useToolchainLibraries = false; };

  rpaths = lib.makeLibraryPath [
    sqlite
    swift-argument-parser
    swift-asn1
    swift-build
    swift-certificates
    swift-collections
    swift-crypto
    swift-driver
    swift-llbuild
    swift-syntax-no-toolchain
    swift-system
    swift-tools-protocols
    swift-tools-support-core
  ];

  swiftPlatform = stdenv.hostPlatform.swift.platform;

  swift' = swift.override {
    enableRepl = false;
    enableSourceKitLSP = false;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swiftpm";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-package-manager";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-package-manager) hash;
  };

  patches = [
    ./patches/0001-gnu-install-dirs.patch
    # SwiftPM tries to use `sandbox-exec` for sandboxing, which will fail when it is run in the Nix sandbox.
    ./patches/0003-disable-sandbox.patch
    # SwiftPM falls back to looking for manifests and plugins in the Swift compiler location. Find them in $out.
    ./patches/0005-fix-manifest-path.patch
    # Silence warnings about not finding the cache folder when building packages by moving it to $NIX_BUILD_TOP.
    ./patches/0006-nix-build-caches.patch
    # SwiftPM does its own `.pc` parsing, so it avoids the `pkg-config` wrapper used in nixpkgs to support
    # cross-compilation. This patch adds support for `"PKG_CONFIG_PATH_FOR_TARGET` to SwiftPM.
    ./patches/0007-nix-pkgconfig-vars.patch
    # SwiftPM assumes that you are using Apple Clang on macOS, but nixpkgs builds Clang from upstream LLVM.
    # This effectively disables using `-index-store-path`, which isn’t supported by LLVM’s Clang.
    ./patches/0008-set-compiler-vendor.patch
    # A couple of required libraries are missing from the `CMakeLists.txt` files.
    ./patches/0009-add-missing-libraries.patch
    # SwiftPM tries to find Clang via `CC`, but that can be GCC on Linux, which doesn’t actually work with SwiftPM.
    ./patches/0011-Always-find-Clang-in-the-toolchain.patch
    # Include the Darwin testing helper in the CMake-built package.
    ./patches/0012-Build-and-install-the-Darwin-testing-helper-for-the-.patch
    # SwiftPM makes assumptions about where the toolchain is that don’t hold in Nixpkgs.
    (replaceVars ./patches/0013-Help-SwiftPM-find-the-toolchain-in-the-store.patch {
      store-dir = builtins.storeDir;
    })
  ];

  postPatch = ''
    # Need to reference $out, so this can’t be substituted by `replaceVars`.
    substituteInPlace Sources/PackageModel/UserToolchain.swift \
      --replace-fail '@out@' "$out"

    # Replace hardcoded references to `xcrun` with `PATH`-based references.
    find Sources -name '*.swift' -exec sed -i '{}' -e 's|/usr/bin/xcrun|xcrun|g' \;

    # Set the deployment target when building package manifests to one supported in nixpkgs.
    substituteInPlace Sources/PackageLoading/ManifestLoader.swift \
      --replace-fail '.tripleString(forPlatformVersion: version)' ".tripleString(forPlatformVersion: \"$MACOSX_DEPLOYMENT_TARGET\")"
  '';

  strictDeps = true;

  # Needed for rpath fixups to work on Darwin.
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift'
  ];

  propagatedBuildInputs = [ swiftpmHook ];

  buildInputs = [
    sqlite
    swift-argument-parser
    swift-asn1
    swift-build
    swift-certificates
    swift-collections
    swift-crypto
    swift-driver
    swift-llbuild
    swift-syntax-no-toolchain
    swift-system
    swift-tools-protocols
    swift-tools-support-core
  ];

  postInstall = ''
    declare -a staticLibs=(
      LLBuildManifest
      PackageFingerprint
      PackageRegistry
      PackageSigning
      SourceKitLSPAPI
      SPMLLBuild
    )

    # Install the swiftmodules.
    mkdir -p "''${!outputDev}/lib/swift/${swiftPlatform}" "''${!outputDev}/lib/swift_static/${swiftPlatform}"
    for f in "''${staticLibs[@]}"; do
      mv -v swift/$f.swiftmodule "''${!outputDev}/lib/swift_static/${swiftPlatform}"
    done
    cp -v swift/*.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

    # Install the static libraries.
    for f in "''${staticLibs[@]}"; do
      cp -v lib/lib$f${stdenv.hostPlatform.extensions.staticLibrary} "''${!outputDev}/lib"
    done

    # Install CMake config file for the SwiftPM library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftPM"
    substitute ${./files/SwiftPMConfig.cmake} "''${!outputDev}/lib/cmake/SwiftPM/SwiftPMConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Replace `@rpath` with absolute paths on Darwin. For some reason, this isn’t always done during installation.
    # `fixDarwinDylibNames` doesn’t work either.
    IFS= readarray -d "" dylibs < <(find "$out" -type f -and -name '*.dylib' -print0)
    declare -a mappings

    for dylib in "''${dylibs[@]}"; do
      mappings+=(-change "@rpath/$(basename "$dylib")" "$dylib")
    done

    for dylib in "''${dylibs[@]}"; do
      install_name_tool "$dylib" ''${mappings[@]}
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isElf ''
    for output in "''${outputs[@]}"; do
      while IFS= read -d "" f; do
        if isELF "$f"; then
          patchelf --add-rpath ${lib.escapeShellArg rpaths} "$f"
        fi
      done < <(find "$output" -type f -print0)
    done
  '';

  passthru.tests = lib.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./tests;
  };

  __structuredAttrs = true;

  meta = {
    description = "Package Manager for the Swift Programming Language";
    homepage = "https://github.com/swiftlang/swift-package-manager";
    inherit (swift.meta) badPlatforms platforms;
    license = lib.licenses.asl20;
    maintainers = lib.teams.swift.members;
  };
})
