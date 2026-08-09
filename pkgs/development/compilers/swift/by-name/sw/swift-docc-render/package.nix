{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs_22,
  fetchpatch2,
  swift_release,
  swift_sources,
}:

# swift-docc-render does not tag releases. Only the built artifacts are tagged. To build this from source:
# 1. Go to https://github.com/swiftlang/swift-docc-render-artifact and check the tagged release for the Swift release;
# 2. Note the parent commit. This will be needed to find the build in Swift’s CI;
# 3. Go to https://ci.swift.org and navigate to the builds for the Swift release being built (e.g., 6.2 for 6.2.4);
# 4. Find the successful build with the same commit for swiftlang/swift-docc-render-artifact as the parent commit for
#    the tagged release. You have to check the parent because Jenkins is reporting the current state of the branch;
# 5. The githubweb link is the commit that was built and tagged in swiftlang/swift-docc-render-artifact.

# For example, for Swift 6.2.4:
# - The parent commit for the pre-built artifact at https://github.com/swiftlang/swift-docc-render-artifact/tree/swift-6.2.4-RELEASE
#   is b2bf4e5426851306760607d79b0bf9af2b6f479b.
# - The successful build with that parent commit is https://ci.swift.org/view/Swift%206.2/job/swift-6.2-docc-render-sync/21/.
# - The corresponding commit on GitHub is https://github.com/swiftlang/swift-docc-render/commit/451103e0f055db233467e4e6b67384cf0d4625a0.
# - The `rev` to use in `src` below is 451103e0f055db233467e4e6b67384cf0d4625a0.

buildNpmPackage (finalAttrs: {
  pname = "swift-docc-render";
  version = "${swift_release}-unstable-2025-09-16";

  # Note! We don’t use the commit from Swift 6.2.4 but a later one that is compatible with Node.js 22.
  # Otherwise, it would require Node.js 20, which is no longer supported in Nixpkgs.
  # This comment can be dropped after the Swift 6.3 update, which includes this commit.
  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-docc-render";
    inherit (swift_sources.swift-docc-render) rev hash;
  };

  nodejs = nodejs_22;

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    inherit (swift_sources.swift-docc-render.npmDeps) hash;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -rv dist "$out/dist"
    runHook postInstall
  '';

  meta = {
    description = "Web renderer for Swift DocC documentation";
    homepage = "https://github.com/swiftlang/swift-docc-render";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
