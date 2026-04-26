{
  makeSetupHook,
  jq,
  yarnVersion,
}:

makeSetupHook {
  name = "yarn-berry-check-version-hook";
  substitutions = {
    inherit yarnVersion;
    jq = "${jq}/bin/jq";
  };
  meta = {
    description = "Check if the version in package.json matches the available version of Yarn";
  };
} ./yarn-berry-check-version-hook.sh
