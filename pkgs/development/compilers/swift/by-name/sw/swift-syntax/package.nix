{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  swift,
  swift_release,
  swift_sources,
  # Using toolchain libraries is intended for building macro library plugins included in the Swift toolchain.
  # Everything else should use a non-toolchain build of Swift Syntax.
  useToolchainLibraries ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-syntax";
  version = swift_release;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-syntax";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-syntax) hash;
  };

  outputs = [ "out" ] ++ lib.optionals (!useToolchainLibraries) [ "dev" ];

  patches = [ ./patches/0001-gnu-install-dirs.patch ];

  strictDeps = true;

  cmakeFlags = lib.optionals (!useToolchainLibraries) [
    # Defaults to not building shared libs.
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Build and install the modules.
    (lib.cmakeBool "SWIFTSYNTAX_EMIT_MODULE" true)
  ];

  nativeBuildInputs = lib.optionals (!useToolchainLibraries) [
    cmake
    ninja
    swift
  ];

  dontConfigure = useToolchainLibraries;

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  dontBuild = useToolchainLibraries;

  postBuild = ''
    # For some reason, this library doesn’t get built even though the install phase expects it to have been.
    ninja -j''${NIX_BUILD_CORES:-1} libSwiftCompilerPlugin${stdenv.hostPlatform.extensions.library}
  '';

  postInstall =
    # Different paths are needed depending on whether we’re providing CMake config for the Swift compiler’s build
    # or for the stand-alone Swift Syntax build.
    if useToolchainLibraries then
      ''
        # Install CMake config file for Swift Syntax in the toolchain. This is needed to build toolchain macros separately
        # from the compiler.
        mkdir -p "''${!outputDev}/lib/cmake/SwiftSyntax"
        substitute ${./files/SwiftSyntaxConfig.cmake} "''${!outputDev}/lib/cmake/SwiftSyntax/SwiftSyntaxConfig.cmake" \
          --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
          --replace-fail '@dev@' ${lib.escapeShellArg swift.swiftc.out} \
          --replace-fail '@lib@' ${lib.escapeShellArg swift.swiftc.out}
      ''
    else
      ''
        moveToOutput lib/swift/host "''${!outputDev}"

        # Install CMake config file for Swift Syntax.
        mkdir -p "''${!outputDev}/lib/cmake/SwiftSyntax"
        substitute ${./files/SwiftSyntaxConfig.cmake} "''${!outputDev}/lib/cmake/SwiftSyntax/SwiftSyntaxConfig.cmake" \
          --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
          --replace-fail '@dev@' "''${!outputDev}" \
          --replace-fail '@lib@/lib/swift/host' "''${!outputLib}/lib"
      '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/swiftlang/swift-syntax";
    description = "Swift libraries for parsing Swift source code";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
