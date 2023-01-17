# SwiftPM dependencies are normally not installed using CMake, and only provide
# CMake modules to link them together in a build tree. We have separate
# derivations, so need a real install step. Here we provide our own minimal
# CMake modules to install along with the build products.
{ lib, stdenv, swift }:
let

  inherit (stdenv.hostPlatform) extensions;

  # This file exports shell snippets for use in postInstall.
  mkInstallScript = module: template: ''
    mkdir -p $out/lib/cmake/${module}
    (
      export staticLibExt="${extensions.staticLibrary}"
      export sharedLibExt="${extensions.sharedLibrary}"
      export swiftOs="${swift.swiftOs}"
      substituteAll \
        ${builtins.toFile "${module}Config.cmake" template} \
        $out/lib/cmake/${module}/${module}Config.cmake
    )
  '';

in lib.mapAttrs mkInstallScript {
  SwiftSystem = ''
    add_library(SwiftSystem::SystemPackage STATIC IMPORTED)
    set_property(TARGET SwiftSystem::SystemPackage PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libSystemPackage@staticLibExt@")
  '';

  SwiftCollections = ''
    add_library(SwiftCollections::Collections STATIC IMPORTED)
    set_property(TARGET SwiftCollections::Collections PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libCollections@staticLibExt@")

    add_library(SwiftCollections::DequeModule STATIC IMPORTED)
    set_property(TARGET SwiftCollections::DequeModule PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libDequeModule@staticLibExt@")

    add_library(SwiftCollections::OrderedCollections STATIC IMPORTED)
    set_property(TARGET SwiftCollections::OrderedCollections PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libOrderedCollections@staticLibExt@")
  '';

  TSC = ''
    add_library(TSCLibc SHARED IMPORTED)
    set_property(TARGET TSCLibc PROPERTY IMPORTED_LOCATION "@out@/lib/libTSCLibc@sharedLibExt@")

    add_library(TSCBasic SHARED IMPORTED)
    set_property(TARGET TSCBasic PROPERTY IMPORTED_LOCATION "@out@/lib/libTSCBasic@sharedLibExt@")

    add_library(TSCUtility SHARED IMPORTED)
    set_property(TARGET TSCUtility PROPERTY IMPORTED_LOCATION "@out@/lib/libTSCUtility@sharedLibExt@")
  '';

  ArgumentParser = ''
    add_library(ArgumentParser SHARED IMPORTED)
    set_property(TARGET ArgumentParser PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libArgumentParser@sharedLibExt@")

    add_library(ArgumentParserToolInfo SHARED IMPORTED)
    set_property(TARGET ArgumentParserToolInfo PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libArgumentParserToolInfo@sharedLibExt@")
  '';

  Yams = ''
    add_library(CYaml SHARED IMPORTED)
    set_property(TARGET CYaml PROPERTY IMPORTED_LOCATION "@out@/lib/libCYaml@sharedLibExt@")

    add_library(Yams SHARED IMPORTED)
    set_property(TARGET Yams PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libYams@sharedLibExt@")
  '';

  LLBuild = ''
    add_library(libllbuild SHARED IMPORTED)
    set_property(TARGET libllbuild PROPERTY IMPORTED_LOCATION "@out@/lib/libllbuild@sharedLibExt@")

    add_library(llbuildSwift SHARED IMPORTED)
    set_property(TARGET llbuildSwift PROPERTY IMPORTED_LOCATION "@out@/lib/swift/pm/llbuild/libllbuildSwift@sharedLibExt@")
  '';

  SwiftDriver = ''
    add_library(SwiftDriver SHARED IMPORTED)
    set_property(TARGET SwiftDriver PROPERTY IMPORTED_LOCATION "@out@/lib/libSwiftDriver@sharedLibExt@")

    add_library(SwiftDriverExecution SHARED IMPORTED)
    set_property(TARGET SwiftDriverExecution PROPERTY IMPORTED_LOCATION "@out@/lib/libSwiftDriverExecution@sharedLibExt@")

    add_library(SwiftOptions SHARED IMPORTED)
    set_property(TARGET SwiftOptions PROPERTY IMPORTED_LOCATION "@out@/lib/libSwiftOptions@sharedLibExt@")
  '';

  SwiftCrypto = ''
    add_library(Crypto SHARED IMPORTED)
    set_property(TARGET Crypto PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libCrypto@sharedLibExt@")
  '';
}
