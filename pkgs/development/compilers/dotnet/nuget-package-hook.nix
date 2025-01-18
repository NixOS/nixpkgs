{
  makeSetupHook,
  buildPackages,
}:
makeSetupHook {
  name = "nuget-package-hook";
  substitutions = {
    inherit (buildPackages) unzip zip xmlstarlet;
    stripNondeterminism = buildPackages.strip-nondeterminism;
  };
} ./nuget-package-hook.sh
