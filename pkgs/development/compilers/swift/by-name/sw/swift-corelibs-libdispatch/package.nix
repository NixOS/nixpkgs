{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  lld,
  ninja,
  stdenv,
  swift-corelibs-libdispatch,
  swift-minimal,
  swift_release,
  swift_sources,
  useSwift ? true, # Where to build the Swift overlay and swiftDispatch shared library.
}:

let
  swift-corelibs-libdispatch-no-overlay = swift-corelibs-libdispatch.override { useSwift = false; };

  swift-corelibs-libdispatch-no-overlay-lib =
    if useSwift then
      lib.escapeShellArg (lib.getLib swift-corelibs-libdispatch-no-overlay)
    else
      placeholder "out";

  swift-corelibs-libdispatch-no-overlay-dev =
    if useSwift then
      lib.escapeShellArg (lib.getDev swift-corelibs-libdispatch-no-overlay)
    else
      placeholder "dev";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-corelibs-libdispatch${lib.optionalString useSwift "-swift-overlay"}";
  version = swift_release;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-corelibs-libdispatch";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-corelibs-libdispatch) hash;
  };

  patches = [
    ./patches/0001-gnu-install-dirs.patch
    # Nixpkgs includes `sys/cdefs.h` from Alpine, which breaks the build due to `-Werror`.
    ./patches/0002-Don-t-include-sys-cdefs-on-Musl.patch
    # Fixes `implicit conversion changes signedness` error.
    (fetchpatch2 {
      url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/38872e2d44d66d2fb94186988509defc734888a5.patch?full_index=1";
      hash = "sha256-BXTv79ej93CBrHtEzHDu+3WkIfzEctwyqBoPkNQQkAA=";
    })
  ];

  strictDeps = true;

  cmakeFlags = [
    # The Swift overlay is built separately using the no-overlay derivation as a base.
    (lib.cmakeBool "ENABLE_SWIFT" useSwift)
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    # Musl requires _GNU_SOURCE or the getprogname shim fails to build.
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-D_GNU_SOURCE=1")
  ]
  ++ lib.optionals stdenv.hostPlatform.isWindows [
    # Linking for Windows requires using LLD.
    (lib.cmakeFeature "CMAKE_LINKER_TYPE" "LLD")
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals useSwift [ swift-minimal ]
  ++ lib.optionals stdenv.hostPlatform.isWindows [ lld ];

  postInstall = ''
    libExt=${stdenv.hostPlatform.extensions.library}

    # Provide a CMake module. This is primarily used to glue together parts of
    # the Swift toolchain. Modifying the CMake config to do this for us is
    # otherwise more trouble.
    mkdir -p "''${!outputDev}/lib/cmake/dispatch"
    substitute ${./files/dispatchConfig.cmake} "''${!outputDev}/lib/cmake/dispatch/dispatchConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform} \
      --replace-fail '@lib@' ${swift-corelibs-libdispatch-no-overlay-lib} \
      --replace-fail '@dev@' ${swift-corelibs-libdispatch-no-overlay-dev} \
      --replace-fail '@out-swift@' "$out" \
      --replace-fail '@dev-swift@' "''${!outputDev}"
  ''
  + lib.optionalString useSwift (
    ''
      mkdir -p "$dev/nix-support" "$man"

      moveToOutput lib/swift "''${!outputDev}"

      # Rely on `propagated-build-inputs` to propagate the non-Swift shared libraries,
      # so with or without overlay uses the same ones.
      rm "''${!outputLib}/lib/libdispatch$libExt" "''${!outputLib}/lib/libBlocksRuntime$libExt"

      ln -s ${lib.escapeShellArg (lib.getMan swift-corelibs-libdispatch-no-overlay)}/* "$man"

      echo -n ${swift-corelibs-libdispatch-no-overlay-dev} >> "$dev/nix-support/propagated-build-inputs"
    ''
    # Clean up the rpaths to reference the non-overlay shared libraries.
    + lib.optionalString stdenv.hostPlatform.isElf ''
      dylib="''${!outputLib}/lib/libswiftDispatch${stdenv.hostPlatform.extensions.sharedLibrary}"
      patchelf --add-rpath ${swift-corelibs-libdispatch-no-overlay-lib}/lib "$dylib"
    ''
  );

  __structuredAttrs = true;

  meta = {
    description = "Grand Central Dispatch";
    homepage = "https://github.com/swiftlang/swift-corelibs-libdispatch";
    platforms = lib.platforms.freebsd ++ lib.platforms.linux ++ lib.platforms.windows;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmm ];
    teams = [ lib.teams.swift ];
  };
})
