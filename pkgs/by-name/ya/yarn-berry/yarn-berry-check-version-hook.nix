{
  makeSetupHook,
}:

makeSetupHook {
  name = "yarn-berry-check-version-hook";
  meta = {
    description = "Check if the version in package.json matches the available version of Yarn";
  };
} ./yarn-berry-check-version-hook.sh
