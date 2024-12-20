{
  lib,
  buildNpmPackage,
  electron_31,
  fetchFromGitHub,
  writers,
  withGui ? false,
}:

let
  electron = electron_31;
in
buildNpmPackage rec {
  pname = "zap-chip";
  version = "2024.09.27";

  src = fetchFromGitHub {
    owner = "project-chip";
    repo = "zap";
    rev = "v${version}";
    hash = "sha256-Dc5rU4jJ6aJpk8mwL+XNSmtisYxF86VzXd/Aacd4p0o=";
  };

  npmDepsHash = "sha256-ZFksGwKlXkz6XTs2QdalGB0hR16HfB69XQOFWI9X/KY=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.CYPRESS_INSTALL_BINARY = "0";

  patches = [
    # the build system creates a file `.version.json` from a git command
    # as we don't build from a git repo, we create the file manually in postPatch
    # and this patch disables the logic running git
    ./dont-get-version-from-git.patch
    # some files are installed via `npx copyfiles` which tries to download
    # code from the internet. This fails in the sandbox. This patch replaces the
    # logic by running "normal" commands instead of `npx copyfiles`
    ./dont-download-copyfiles-to-copy-files.patch
  ];

  postPatch =
    let
      versionJson = {
        hash = version;
        timestamp = 1;
        date = version;
        zapVersion = version;
      };
    in
    ''
      cp ${writers.writeJSON "zapversion.json" versionJson} .version.json
      cat .version.json
    '';

  postBuild = lib.optionalString withGui ''
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
  '';

  postInstall =
    ''
      # this file is also used at runtime
      install -m644 .version.json $out/lib/node_modules/zap/
    ''
    + lib.optionalString (!withGui) ''
      # home-assistant chip-* python packages need the executable under the name zap-cli
      mv $out/bin/zap $out/bin/zap-cli
    '';

  meta = {
    description = "Generic generation engine and user interface for applications and libraries based on Zigbee Cluster Library (ZCL)";
    changelog = "https://github.com/project-chip/zap/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ symphorien ];
    mainProgram = "zap" + lib.optionalString (!withGui) "-cli";
  };
}
