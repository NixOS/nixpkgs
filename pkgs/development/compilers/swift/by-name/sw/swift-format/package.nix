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
  pname = "swift-format";
  version = swift_release;

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-format";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-format) hash;
  };

  strictDeps = true;

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    inherit (swift_sources.swift-format.swiftpmDeps) hash;

    # Upstream doesn’t provide `Package.resolved`.
    postPatch = ''
      ln -s ${./Package.resolved} Package.resolved
    '';
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  __structuredAttrs = true;

  meta = {
    mainProgram = "swift-format";
    homepage = "https://github.com/swiftlang/swift-format";
    description = "Swift code formatter";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
