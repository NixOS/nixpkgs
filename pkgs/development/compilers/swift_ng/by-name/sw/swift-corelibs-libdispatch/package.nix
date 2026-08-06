{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  lld,
  ninja,
  stdenv,
  swift-corelibs-libdispatch,
  swift_release,
  swift_sources,
}:

let
  swift-corelibs-libdispatch-no-overlay-lib = placeholder "out";
  swift-corelibs-libdispatch-no-overlay-dev = placeholder "dev";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-corelibs-libdispatch";
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
    (lib.cmakeBool "ENABLE_SWIFT" false)
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
  '';

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
