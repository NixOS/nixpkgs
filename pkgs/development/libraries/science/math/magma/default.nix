args@{ callPackage
, lib
, ...
}:

# Type aliases
# Release = {
#  version: String
#  hash: String
#  supportedGpuTargets: List String
# }

let
  inherit (lib) lists strings trivial;

  computeName = version: "magma_${strings.replaceStrings [ "." ] [ "_" ] version}";

  # buildMagmaPackage :: Release -> Derivation
  buildMagmaPackage = magmaRelease: callPackage ./generic.nix (
    (builtins.removeAttrs args [ "callPackage" ]) // {
      inherit magmaRelease;
    }
  );

  # Reverse the list to have the latest release first
  # magmaReleases :: List Release
  magmaReleases = lists.reverseList (builtins.import ./releases.nix);

  # The latest release is the first element of the list and will be our default choice
  # latestReleaseName :: String
  latestReleaseName = computeName (builtins.head magmaReleases).version;

  # Function to transform our releases into build attributes
  # toBuildAttrs :: Release -> { name: String, value: Derivation }
  toBuildAttrs = release: {
    name = computeName release.version;
    value = buildMagmaPackage release;
  };

  # Add all supported builds as attributes
  # allBuilds :: AttrSet String Derivation
  allBuilds = builtins.listToAttrs (lists.map toBuildAttrs magmaReleases);

  # The latest release will be our default build
  # defaultBuild :: AttrSet String Derivation
  defaultBuild.magma = allBuilds.${latestReleaseName};

  # builds :: AttrSet String Derivation
  builds = allBuilds // defaultBuild;
in

builds

