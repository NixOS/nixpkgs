# TODO: We already package the CoreFoundation component of Foundation in:
#   pkgs/os-specific/darwin/swift-corelibs/corefoundation.nix
# This is separate because the CF build is completely different and part of
# stdenv. Merging the two was kept outside of the scope of Swift work.

{ lib
, stdenv
, callPackage
, cmake
, ninja
, swift
, Dispatch
, icu
, libxml2
, curl
}:

let
  sources = callPackage ../sources.nix { };
in stdenv.mkDerivation {
  pname = "swift-corelibs-foundation";

  inherit (sources) version;
  src = sources.swift-corelibs-foundation;

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ninja swift ];
  buildInputs = [ icu libxml2 curl ];
  propagatedBuildInputs = [ Dispatch ];

  preConfigure = ''
    # Fails to build with -D_FORTIFY_SOURCE.
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}
  '';

  postInstall = ''
    # Split up the output.
    mkdir $dev
    mv $out/lib/swift/${swift.swiftOs} $out/swiftlibs
    mv $out/lib/swift $dev/include
    mkdir $out/lib/swift
    mv $out/swiftlibs $out/lib/swift/${swift.swiftOs}

    # Provide a CMake module. This is primarily used to glue together parts of
    # the Swift toolchain. Modifying the CMake config to do this for us is
    # otherwise more trouble.
    mkdir -p $dev/lib/cmake/Foundation
    export dylibExt="${stdenv.hostPlatform.extensions.sharedLibrary}"
    export swiftOs="${swift.swiftOs}"
    substituteAll ${./glue.cmake} $dev/lib/cmake/Foundation/FoundationConfig.cmake
  '';

  meta = {
    description = "Core utilities, internationalization, and OS independence for Swift";
    homepage = "https://github.com/apple/swift-corelibs-foundation";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dtzWill trepetti dduan trundle stephank ];
  };
}
