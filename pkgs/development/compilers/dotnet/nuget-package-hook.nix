{
  makeSetupHook,
  unzip,
  zip,
  xmlstarlet,
  strip-nondeterminism,
}:
makeSetupHook {
  name = "nuget-package-hook";
  substitutions = {
    inherit unzip zip xmlstarlet;
    stripNondeterminism = strip-nondeterminism;
  };
} ./nuget-package-hook.sh
