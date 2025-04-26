{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  python3,
  xdg-utils,
  electron,
  makeDesktopItem,
  stdenv,
  zip,
}:
let
  base = rec {
    pname = "webcord";
    version = "4.10.4";

    src = fetchFromGitHub {
      owner = "SpacingBat3";
      repo = "WebCord";
      tag = "v${version}";
      hash = "sha256-rBOQutAPmNiw9bJ3nYSddbAwSqYHAlSNHpkMvxzmUnA=";
    };

    npmDepsHash = "sha256-CjXEwFRGVjJv+kuyq9IZHdiYKJ6lbSDZnIxBer3qnOI=";

    makeCacheWritable = true;

    nativeBuildInputs = [
      copyDesktopItems
      python3
      zip
    ];

    env = {
      # npm install will error when electron tries to download its binary
      # we don't need it anyways since we wrap the program with our nixpkgs electron
      ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

      # Build Flags in Electron Forge for WebCord
      # DOCS: https://github.com/SpacingBat3/WebCord/blob/master/docs/Flags.md
      WEBCORD_BUILD = "release"; # WebCord is usually built in release mode
      WEBCORD_ASAR = "true"; # default is true for WebCord
      WEBCORD_UPDATE_NOTIFICATIONS = "false"; # Disable update notifications
    };

    # remove husky commit hooks, errors and aren't needed for packaging
    postPatch = ''
      rm -rf .husky
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      description = "A Discord and SpaceBar electron-based client implemented without Discord API";
      homepage = "https://github.com/SpacingBat3/WebCord";
      downloadPage = "https://github.com/SpacingBat3/WebCord/releases";
      changelog = "https://github.com/SpacingBat3/WebCord/releases/tag/v${version}";
      license = lib.licenses.mit;
      mainProgram = "webcord";
      maintainers = with lib.maintainers; [
        huantian
        NotAShelf
      ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };

  linuxArgs =
    let
      inherit (base) meta;
    in
    {
      # override installPhase so we can copy the only folders that matter
      installPhase =
        let
          binPath = lib.makeBinPath [ xdg-utils ];
        in
        ''
          runHook preInstall

          # Remove dev deps that aren't necessary for running the app
          npm prune --omit=dev --no-save

          # Copy files to the output directory
          mkdir -p $out/lib/node_modules/webcord
          cp -r app node_modules sources package.json $out/lib/node_modules/webcord/

          # Install the app icon
          install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

          # Add xdg-utils to path via suffix, per PR #181171
          makeWrapper '${lib.getExe electron}' $out/bin/webcord \
            --suffix PATH : "${binPath}" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
            --add-flags $out/lib/node_modules/webcord/

          runHook postInstall
        '';

      desktopItems = lib.optionals stdenv.isLinux [
        (makeDesktopItem {
          name = "webcord";
          exec = "webcord";
          icon = "webcord";
          desktopName = "WebCord";
          comment = meta.description;
          categories = [
            "Network"
            "InstantMessaging"
          ];
        })
      ];
    };

  darwinArgs =
    let
      inherit (base) version;

      platform = "darwin";
      arch = if stdenv.isAarch64 then "arm64" else "x64";

      electronZipPath = "nix-electron-zip";
      electronNewFolderName = "electron-v${electron.version}-darwin-arm64";
      electronZipFile = "${electronNewFolderName}.zip";
      electronVersion = electron.version;
    in
    {
      preBuild = ''
        # Set build flags
        # DOCS: https://github.com/SpacingBat3/WebCord/blob/master/docs/Flags.md
        cat > buildInfo.json <<EOF
        {
          "type": "release",
          "features": { "updateNotifications": false }
        }
        EOF

        # zip electron for use by electron-packager
        mkdir -p nix-electron-zip
        cp -r ${electron}/Applications ${electronZipPath}/${electronNewFolderName}
        chmod -R 755 ${electronZipPath}/${electronNewFolderName}
        cd ${electronZipPath}/${electronNewFolderName}
        zip -r ../${electronZipFile} Electron.app
        cd ../..
        rm -rf ${electronZipPath}/${electronNewFolderName}
      '';

      # override the buildPhase for darwin
      buildPhase = ''
        runHook preBuild

        # compile TS to JS
        npx tsc

        # package for macOS for arm64 and x64
        npx electron-packager . WebCord \
          --platform=${platform} \
          --arch=${arch} \
          --out=$out \
          --overwrite \
          --app-bundle-id=com.electron.webcord \
          --app-version=${version} \
          --asar \
          --electron-version=${electronVersion} \
          --electron-zip-dir=${electronZipPath} \
          --icon=sources/assets/icons/app.icns

        runHook postBuild
      '';

      # clean up the build directory
      postBuild = ''
        # Remove the zip file
        rm -rf ${electronZipPath}
      '';

      installPhase = ''
        runHook preInstall

        # Remove dev deps that aren't necessary for running the app
        npm prune --omit=dev --no-save

        # Rename the output folder to the standard name
        mv $out/WebCord-${platform}-${arch}/ $out/Applications/

        runHook postInstall;
      '';
    };
in
buildNpmPackage (if stdenv.isLinux then base // linuxArgs else base // darwinArgs)
