# TODO: We already package the CoreFoundation component of Foundation in:
#   pkgs/os-specific/darwin/swift-corelibs/corefoundation.nix
# This is separate because the CF build is completely different and part of
# stdenv. Merging the two was kept outside of the scope of Swift work.

{
  lib,
  stdenv,
  fetchpatch,
  callPackage,
  cmake,
  ninja,
  swift,
  Dispatch,
  icu,
  libxml2,
  curl,
}:

let
  sources = callPackage ../sources.nix { };
in
stdenv.mkDerivation {
  pname = "swift-corelibs-foundation";

  inherit (sources) version;
  src = sources.swift-corelibs-foundation;

  patches = [
    # from https://github.com/apple/swift-corelibs-foundation/pull/4811
    # fix build with glibc >=2.38
    (fetchpatch {
      url = "https://github.com/apple/swift-corelibs-foundation/commit/47260803a108c6e0d639adcebeed3ac6a76e8bcd.patch";
      hash = "sha256-1JUSQW86IHKkBZqxvpk0P8zcSKntzOTNlMoGBfgeT4c=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    swift
  ];
  buildInputs = [
    icu
    libxml2
    curl
  ];
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
    mainProgram = "plutil";
    homepage = "https://github.com/apple/swift-corelibs-foundation";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = lib.teams.swift.members;
  };
}
