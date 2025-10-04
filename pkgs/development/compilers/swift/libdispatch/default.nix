{
  lib,
  stdenv,
  callPackage,
  fetchpatch,
  cmake,
  ninja,
  useSwift ? true,
  swift,
}:

let
  sources = callPackage ../sources.nix { };
in
stdenv.mkDerivation {
  pname = "swift-corelibs-libdispatch";

  inherit (sources) version;
  src = sources.swift-corelibs-libdispatch;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals useSwift [
    ninja
    swift
  ];

  patches = [
    # Fix the build with modern Clang.
    (fetchpatch {
      url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/30bb8019ba79cdae0eb1dc0c967c17996dd5cc0a.patch";
      hash = "sha256-wPZQ4wtEWk8HaKMfzjamlU6p/IW5EFiTssY63rGM+ZA=";
    })

    ./disable-swift-overlay.patch
  ];

  cmakeFlags = lib.optional useSwift "-DENABLE_SWIFT=ON";

  postInstall = ''
    # Provide a CMake module. This is primarily used to glue together parts of
    # the Swift toolchain. Modifying the CMake config to do this for us is
    # otherwise more trouble.
    mkdir -p $dev/lib/cmake/dispatch
    export dylibExt="${stdenv.hostPlatform.extensions.sharedLibrary}"
    substituteAll ${./glue.cmake} $dev/lib/cmake/dispatch/dispatchConfig.cmake
  '';

  meta = {
    description = "Grand Central Dispatch";
    homepage = "https://github.com/apple/swift-corelibs-libdispatch";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmm ];
    teams = [ lib.teams.swift ];
  };
}
