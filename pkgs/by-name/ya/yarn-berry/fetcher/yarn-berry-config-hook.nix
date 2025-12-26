{
  makeSetupHook,
  yarn-berry-offline,
  srcOnly,
  nodejs,
  diffutils,
}:

makeSetupHook {
  name = "yarn-berry-config-hook";
  substitutions = {
    # Specify `diff` by abspath to ensure that the user's build
    # inputs do not cause us to find the wrong binaries.
    diff = "${diffutils}/bin/diff";

    yarn_offline = "${yarn-berry-offline}/bin/yarn";

    nodeSrc = srcOnly nodejs;
    nodeGyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";
  };
  meta = {
    description = "Install nodejs dependencies from an offline yarn cache produced by fetchYarnDeps";
  };
} ./yarn-berry-config-hook.sh
