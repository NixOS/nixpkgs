{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  darwin,
  swift_release,
  swift_sources,
}:

stdenvNoCC.mkDerivation {
  pname = "swift-foundation-icu";
  version = lib.getVersion darwin.ICU;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-foundation-icu";
    tag = "swift-${swift_release}-RELEASE";
    inherit (swift_sources.swift-foundation-icu) hash;
  };

  propagatedBuildInputs = [ (lib.getLib darwin.ICU) ];

  buildCommand = ''
    runPhase unpackPhase

    # Provide a CMake module. This is primarily used to glue together parts of the Swift toolchain.
    # Upstream provides a build that does this for us, but we want to reuse our existing ICU build.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftFoundationICU"
    export dylibExt="${stdenvNoCC.hostPlatform.extensions.sharedLibrary}"

    substitute ${./files/SwiftFoundationICUConfig.cmake} "''${!outputDev}/lib/cmake/SwiftFoundationICU/SwiftFoundationICUConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenvNoCC.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@lib@' ${lib.escapeShellArg (lib.getLib darwin.ICU)} \
      --replace-fail '@dev@' "''${!outputDev}"

    # Copy headers to `_foundation_unicode`. The translation is needed to make sure they’re found in the tooclhain.
    mkdir -p "$out/lib/swift/_foundation_unicode"
    for header in ${lib.escapeShellArg (lib.getInclude darwin.ICU)}/include/unicode/*; do
      # Not all files include other files, so these can’t be `--replace-fail`. Use both `"` and `<` to be thorough.
      substitute "$header" "$out/lib/swift/_foundation_unicode/$(basename "$header")" \
        --replace-quiet 'include "unicode/' 'include "_foundation_unicode/' \
        --replace-quiet 'include <unicode/' 'include <_foundation_unicode/'
    done
    cp icuSources/include/_foundation_unicode/module.modulemap "$out/lib/swift/_foundation_unicode/module.modulemap"

    recordPropagatedDependencies
  '';

  meta = {
    description = "Shim package allowing the Darwin ICU packaging to be used with Swift Foundation.";
    inherit (darwin.ICU.meta) license platforms;
    teams = [ lib.teams.swift ];
  };
}
