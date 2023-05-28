# Support matrix can be found at
# https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-880/support-matrix/index.html
# Type aliases
# Release = {
#   version: String,
#   minCudaVersion: String,
#   maxCudaVersion: String,
#   url: String,
#   hash: String,
# }
final: prev: let
  inherit (final) callPackage;
  inherit (prev) cudaVersion;
  inherit (prev.lib) attrsets lists versions;
  inherit (prev.lib.strings) replaceStrings versionAtLeast versionOlder;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: String -> String
  computeName = version: "cudnn_${replaceStrings ["."] ["_"] (versions.majorMinor version)}";

  # Check whether a CUDNN release supports our CUDA version
  # Thankfully we're able to do lexicographic comparison on the version strings
  # isSupported :: Release -> Bool
  isSupported = release:
    versionAtLeast cudaVersion release.minCudaVersion
    && versionAtLeast release.maxCudaVersion cudaVersion;

  # useCudatoolkitRunfile :: Bool
  useCudatoolkitRunfile = versionOlder cudaVersion "11.3.999";

  # buildCuDnnPackage :: Release -> Derivation
  buildCuDnnPackage = callPackage ./generic.nix {inherit useCudatoolkitRunfile;};

  # Reverse the list to have the latest release first
  # cudnnReleases :: List Release
  cudnnReleases = lists.reverseList (builtins.import ./releases.nix);

  # Check whether a CUDNN release supports our CUDA version
  # supportedReleases :: List Release
  supportedReleases = builtins.filter isSupported cudnnReleases;

  # Function to transform our releases into build attributes
  # toBuildAttrs :: Release -> { name: String, value: Derivation }
  toBuildAttrs = release: {
    name = computeName release.version;
    value = buildCuDnnPackage release;
  };

  # Add all supported builds as attributes
  # allBuilds :: AttrSet String Derivation
  allBuilds = builtins.listToAttrs (builtins.map toBuildAttrs supportedReleases);

  defaultBuild = attrsets.optionalAttrs (supportedReleases != []) {
    cudnn = let
      # The latest release is the first element of the list and will be our default choice
      # latestReleaseName :: String
      latestReleaseName = computeName (builtins.head supportedReleases).version;
    in
      allBuilds.${latestReleaseName};
  };

  # builds :: AttrSet String Derivation
  builds = allBuilds // defaultBuild;
in
  builds
