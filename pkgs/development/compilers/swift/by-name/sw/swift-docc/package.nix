{
  lib,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  stdenv,
  swift,
  swiftpm,
  swift_release,
  swift_sources,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-docc";
  version = swift_release;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-docc";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-docc) hash;
  };

  postPatch = ''
    # SignalTests.testTrappingSignal tries to access `/bin/bash`. Replace it with the shell in the stdenv.
    substituteInPlace Tests/SwiftDocCUtilitiesTests/SignalTests.swift \
      --replace-fail '/bin/bash' ${lib.escapeShellArg stdenv.shell}
  '';

  strictDeps = true;

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    inherit (swift_sources.swift-docc.swiftpmDeps) hash;
  };

  swiftpmFlags = [
    # Otherwise fails to build with `error: module 'SwiftDocC' was not compiled for testing`.
    "-Xswiftc"
    "-enable-testing"
  ];

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  __structuredAttrs = true;

  meta = {
    description = "Documentation compiler for Swift";
    mainProgram = "docc";
    homepage = "https://github.com/swiftlang/swift-docc";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
