{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  python3,
  xdg-utils,
  electron_43,
  makeDesktopItem,
  nodejs_22,
  darwin,
}:

buildNpmPackage.override { nodejs = nodejs_22; } rec {
  pname = "webcord";
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "SpacingBat3";
    repo = "WebCord";
    tag = "v${version}";
    hash = "sha256-YmgKkSC54asDRy0kGsXfZT6AasrU4GtJzPWVrtO0xws=";
  };

  npmDepsHash = "sha256-ozo1jb7TXVBHIgYoFKTJKmbLpnOdMcGAM/uTJWJVu1I=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  # npm install will error when electron tries to download its binary
  # we don't need it anyways since we wrap the program with our nixpkgs electron
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # remove husky commit hooks, errors and aren't needed for packaging
  postPatch = ''
    rm -rf .husky
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # fix font rendering on about page
    substituteInPlace sources/assets/web/css/fonts.css \
      --replace-fail 'sans-serif, Twemoji' 'sans-serif, "Helvetica Neue", Twemoji' \
      --replace-fail 'monospace, Twemoji' 'monospace, Menlo, Twemoji'
  '';

  # override installPhase so we can copy the only folders that matter
  installPhase =
    let
      binPath = lib.makeBinPath [ xdg-utils ];
      infoPlist = lib.generators.toPlist { escape = true; } {
        CFBundleName = "WebCord";
        CFBundleExecutable = "Electron";
        CFBundleIconFile = "webcord.icns";
        CFBundleIdentifier = "io.github.spacingbat3.webcord";
        CFBundleShortVersionString = version;
        CFBundleVersion = version;
        LSApplicationCategoryType = "public.app-category.social-networking";
        LSEnvironment.MallocNanoZone = "0";
        NSHighResolutionCapable = true;
        NSPrincipalClass = "AtomApplication";
        NSCameraUsageDescription = "Camera access";
        NSMicrophoneUsageDescription = "Mic access";
      };
      buildInfo = builtins.toJSON { type = "release"; };
    in
    ''
      runHook preInstall

      # Remove dev deps that aren't necessary for running the app
      npm prune --omit=dev

      mkdir -p $out/lib/node_modules/webcord
      cp -r app node_modules sources package.json $out/lib/node_modules/webcord/
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

      # Add xdg-utils to path via suffix, per PR #181171
      makeWrapper '${lib.getExe electron_43}' $out/bin/webcord \
        --suffix PATH : "${binPath}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags $out/lib/node_modules/webcord/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications

      app=$out/Applications/WebCord.app
      cp -r ${electron_43.dist}/Electron.app $app
      chmod -R +w $app

      ln -s $out/lib/node_modules/webcord $app/Contents/Resources/app
      install -Dm644 sources/assets/icons/app.icns $app/Contents/Resources/webcord.icns
      cp ${builtins.toFile "Info.plist" infoPlist} $app/Contents/Info.plist
      cp ${builtins.toFile "buildInfo.json" buildInfo} $app/Contents/Resources/app/buildInfo.json
    ''
    + ''
      runHook postInstall
    '';

  desktopItems = [
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Discord and SpaceBar electron-based client implemented without Discord API";
    homepage = "https://github.com/SpacingBat3/WebCord";
    downloadPage = "https://github.com/SpacingBat3/WebCord/releases";
    changelog = "https://github.com/SpacingBat3/WebCord/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "webcord";
    maintainers = with lib.maintainers; [
      eclairevoyant
      huantian
      NotAShelf
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
