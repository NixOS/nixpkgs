{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  writers,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "zap-chip";
  version = "2026.05.21";

  src = fetchFromGitHub {
    owner = "project-chip";
    repo = "zap";
    rev = "v${version}";
    hash = "sha256-rX8WTaQQbVWlabMEvv5SCalxy0XmB5jFpCk1uQCbunM=";
  };

  npmDepsHash = "sha256-R95ljHvKPGyJh3tlWI1feo9HVE7abPLVLzScqReJBPw=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.CYPRESS_INSTALL_BINARY = "0";

  patches = [
    # The release's package-lock.json file is not universal. It misses
    # architecture-related packages, caused by an NPM bug. Add these to the
    # lock otherwise `npm ci` complains.
    # Regenerate the patch by `npm install --package-lock-only`
    # https://github.com/npm/cli/issues/8805
    ./universal-npm-lock.patch
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

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # this file is also used at runtime
    install -m644 .version.json $out/lib/node_modules/zap/
    # home-assistant chip-* python packages need the executable under the name zap-cli
    mv $out/bin/zap $out/bin/zap-cli
  '';

  meta = {
    description = "Generic generation engine and user interface for applications and libraries based on Zigbee Cluster Library (ZCL)";
    changelog = "https://github.com/project-chip/zap/releases/tag/v${version}";
    homepage = "https://github.com/project-chip/zap";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ symphorien ];
    mainProgram = "zap-cli";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
