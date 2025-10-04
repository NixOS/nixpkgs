{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  moreutils,
  nodejs,
  nodePackages,
  jq,
}:

buildNpmPackage rec {
  pname = "witsy";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "nbonamy";
    repo = "witsy";
    tag = "v${version}";
    hash = "sha256-YW07wBx5Ybf+87gTY6QhxuK772kNo64qqED9RCPa/uw=";
  };

  npmDepsHash = "sha256-9r66P6T1heLV+eJN2TvXQYwcUeKkLkipqf45LiBOdKQ=";

  nativeBuildInputs = [
    copyDesktopItems
    nodejs
  ];

  forceGitDeps = true;

  makeCacheWritable = true;

  npmFlags = [ "--ignore-scripts" ];

  postPatch = ''
    # Remove the problematic Git dependency @vue/test-utils which has install scripts requiring rollup
    # This is a dev dependency used for testing and not needed for the build
    ${lib.getExe jq} 'del(.devDependencies."@vue/test-utils")' package.json | ${lib.getExe' moreutils "sponge"} package.json
    ${lib.getExe jq} '
      del(.devDependencies."@vue/test-utils") |
      walk(
        if type == "object" and has("packages") then
          .packages |= with_entries(select(.key | contains("@vue/test-utils") | not))
        else .
        end
      )
    ' package-lock.json | ${lib.getExe' moreutils "sponge"} package-lock.json

    # Remove @electron-forge/publisher-github to avoid network requests during build
    ${lib.getExe jq} 'del(.devDependencies."@electron-forge/publisher-github")' package.json | ${lib.getExe' moreutils "sponge"} package.json
    ${lib.getExe jq} '
      walk(
        if type == "object" and has("packages") then
          .packages |= with_entries(select(.key | contains("@electron-forge/publisher-github") | not))
        else .
        end
      )
    ' package-lock.json | ${lib.getExe' moreutils "sponge"} package-lock.json

    # no need to patch this, will be removed, but error still persists
    # substituteInPlace package.json \
    #   --replace-fail '    "@electron-forge/publisher-github": "^7.4.0",' ""
  '';

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.electronDist = electron.dist;

  preConfigure = ''
    export npm_config_offline="false"
    export npm_config_ignore_scripts="true"
  '';

  npmBuildScript = "package";

  npmConfigCache = "/tmp/npm-cache";

  desktopItems = [
    (makeDesktopItem {
      name = "witsy";
      exec = "witsy %U";
      icon = "witsy";
      desktopName = "Witsy";
      genericName = "LLM Chat App";
      comment = "Interact with LLMs";
      categories = [ "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/witsy $out/share/applications

    # Copy the built app
    cp -r out/Witsy-linux-x64/resources/app $out/share/witsy/

    # Wrap electron
    makeWrapper ${electron}/bin/electron $out/bin/witsy \
      --add-flags $out/share/witsy \
      --set ELECTRON_IS_PACKAGED 1

    runHook postInstall
  '';

  meta = {
    description = "An app to interact with LLMs";
    homepage = "https://github.com/nbonamy/witsy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uri-zafrir ];
    platforms = electron.meta.platforms;
    mainProgram = "witsy";
  };
}