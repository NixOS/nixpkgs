# Native N-API addons that need compilation because --ignore-scripts skips
# their install hooks (prebuild-install / node-gyp rebuild).
#
# Windows-only modules (crash-dump, winapi-bindings, native-errors) are no-ops on Linux.
# leveldown ships bundled prebuilds (prebuilds/linux-x64/node.napi.glibc.node).
{lib}: let
  addons = [
    {
      name = "vortexmt";
      preBuild = "../../node_modules/.bin/autogypi";
    }
    {name = "xxhash-addon";}
    {name = "diskusage";}
    {name = "drivelist";}
  ];

  addonNames = map (a: a.name) addons;
in {
  inherit addons addonNames;

  # Build all addons via node-gyp in root node_modules/
  buildScript = lib.concatMapStringsSep "\n" (addon: ''
    echo "Building native addon: ${addon.name}"
    pushd node_modules/${addon.name}
    ${lib.optionalString (addon ? preBuild) addon.preBuild}
    ../../node_modules/.bin/node-gyp rebuild
    popd
  '') addons;

  # Copy compiled builds from root node_modules/ into app/node_modules/
  # (electron-builder packages from app/, not root)
  copyToAppScript = lib.concatMapStringsSep "\n" (name: ''
    cp -r ../node_modules/${name}/build node_modules/${name}/ 2>/dev/null || true
  '') addonNames;
}
