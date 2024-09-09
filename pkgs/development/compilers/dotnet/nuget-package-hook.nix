{
  makeSetupHook,
  zip,
  strip-nondeterminism,
}:
makeSetupHook {
  name = "nuget-package-hook";
  substitutions = {
    inherit zip;
    stripNondeterminism = strip-nondeterminism;
  };
} ./nuget-package-hook.sh
