{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, useSwift ? true, swift
}:

stdenv.mkDerivation rec {
  pname = "swift-corelibs-libdispatch";

  # Releases are made as part of the Swift toolchain, so versions should match.
  version = "5.7";
  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-corelibs-libdispatch";
    rev = "swift-${version}-RELEASE";
    hash = "sha256-1qbXiC1k9+T+L6liqXKg6EZXqem6KEEx8OctuL4Kb2o=";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optionals useSwift [ ninja swift ];

  patches = [ ./disable-swift-overlay.patch ];

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
