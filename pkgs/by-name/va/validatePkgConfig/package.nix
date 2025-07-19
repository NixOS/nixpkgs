{
  makeSetupHook,
  findutils,
  pkg-config,
}:

makeSetupHook {
  name = "validate-pkg-config";
  propagatedBuildInputs = [
    findutils
    pkg-config
  ];
} ./hook.sh
