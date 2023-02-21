{ lib
, stdenv
, callPackage
, fetchpatch
, cmake
, ninja
, useSwift ? true, swift
}:

let
  sources = callPackage ../sources.nix { };
in stdenv.mkDerivation {
  pname = "swift-corelibs-libdispatch";

  inherit (sources) version;
  src = sources.swift-corelibs-libdispatch;

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optionals useSwift [ ninja swift ];

  patches = [
    ./disable-swift-overlay.patch

    # Needed to build with clang 15+ without disabling warnings; can drop this
    # once we update to 5.8.x.
    (fetchpatch {
      name = "swift-corelibs-libdispatch-fix-unused-but-set-warning";
      url = "https://github.com/apple/swift-corelibs-libdispatch/commit/915f25141a7c57b6a2a3bc8697572644af181ec5.patch";
      sha256 = "sha256-gxhMwSlE/y4LkOvmCaDMPjd7EcoX6xaacK4MLa3mOUM=";
      includes = ["src/shims/yield.c"];
    })
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
    maintainers = with lib.maintainers; [ cmm dtzWill trepetti dduan trundle stephank ];
  };
}
