{
  lib,
  stdenv,
  buildNpmPackage,
  electron,
  fetchFromGitHub,
  writers,
  makeWrapper,
  withGui ? false,
}:

buildNpmPackage rec {
  pname = "zap-chip";
  version = "2025.02.26";

  src = fetchFromGitHub {
    owner = "project-chip";
    repo = "zap";
    rev = "v${version}";
    hash = "sha256-oYw1CxeCr4dUpw7hhXjtB+QwTfBI7rG9jgfxWKZYsSc=";
  };

  npmDepsHash = "sha256-dcnJfxgF1S2gyR+wPnBD4AFzix5Sdq2ZqDlXvWAFb8s=";

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

  nativeBuildInputs = [ makeWrapper ];

  postInstall =
    ''
      # this file is also used at runtime
      install -m644 .version.json $out/lib/node_modules/zap/
    ''
    + lib.optionalString (!withGui) ''
      # home-assistant chip-* python packages need the executable under the name zap-cli
      mv $out/bin/zap $out/bin/zap-cli
    ''
    + lib.optionalString withGui ''
      pushd dist/linux-*unpacked
      mkdir -p $out/opt/zap-chip
      cp -r locales resources{,.pak} $out/opt/zap-chip
      popd

      rm $out/bin/zap
      makeWrapper '${lib.getExe electron}' "$out/bin/zap" \
        --add-flags $out/opt/zap-chip/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0
    '';

  meta = {
    description = "Generic generation engine and user interface for applications and libraries based on Zigbee Cluster Library (ZCL)";
    changelog = "https://github.com/project-chip/zap/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ symphorien ];
    mainProgram = "zap" + lib.optionalString (!withGui) "-cli";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
