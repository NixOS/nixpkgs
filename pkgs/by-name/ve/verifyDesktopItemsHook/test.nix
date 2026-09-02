{
  lib,
  stdenvNoCC,
  linkFarm,
  makeDesktopItem,
  copyDesktopItems,
  verifyDesktopItemsHook,
  testers,
}:

let

  mkTestDrv =
    variant:
    let
      desktopItem = makeDesktopItem {
        name = "mytool";
        desktopName = "My Tool";
        exec =
          {
            badExec = "/usr/bin/mytool";
            noExec = null;
          }
          .${variant} or "mytool";
        icon =
          {
            badIcon = "/usr/share/icons/hicolor/256x256/apps/mytool.png";
            standardIcon = "utilities-terminal";
            noIcon = null;
          }
          .${variant} or "mytool";
      };

      binDir = if variant == "goodSbin" then "sbin" else "bin";
    in
    stdenvNoCC.mkDerivation {
      name = "verify-desktop-items-hook-test-${variant}";

      dontUnpack = true;
      doInstallCheck = true;

      nativeBuildInputs = [
        copyDesktopItems
        verifyDesktopItemsHook
      ];

      desktopItems = lib.optional (
        !lib.elem variant [
          "badSyntax"
          "badValues"
          "noItems"
        ]
      ) desktopItem;

      verifyDesktopItemsSkip = lib.optional (variant == "skip") "broken.desktop";

      installPhase = ''
        mkdir -p $out/${binDir} "$out/share/icons/hicolor/256x256/apps"
        echo '#!/bin/sh' > "$out/${binDir}/mytool"
        chmod +x "$out/${binDir}/mytool"
        touch "$out/share/icons/hicolor/256x256/apps/mytool.png"
      ''
      + lib.optionalString (variant == "badSyntax") ''
        mkdir -p $out/share/applications
        cat > $out/share/applications/broken.desktop <<'DESKTOP'
        [Desktop Entry
        Type=Application
        Name=Broken
        Exec=mytool
        DESKTOP
      ''
      + lib.optionalString (variant == "badValues" || variant == "skip") ''
        mkdir -p $out/share/applications
        cat > $out/share/applications/broken.desktop <<'DESKTOP'
        [Desktop Entry]
        Type=NotAValidType
        Name=Broken
        Exec=mytool
        DESKTOP
      ''
      + ''
        runHook postInstall
      '';
    };
in
linkFarm "verify-desktop-items-hook-tests" {
  good = mkTestDrv "good";
  goodSbin = mkTestDrv "goodSbin";
  noExec = mkTestDrv "noExec";
  noIcon = mkTestDrv "noIcon";
  noItems = mkTestDrv "noItems";
  skip = mkTestDrv "skip";
  standardIcon = mkTestDrv "standardIcon";

  badExec = testers.testBuildFailure' {
    drv = mkTestDrv "badExec";
    expectedBuilderLogEntries = [
      "Exec command '/usr/bin/mytool' referenced"
    ];
  };

  badIcon = testers.testBuildFailure' {
    drv = mkTestDrv "badIcon";
    expectedBuilderLogEntries = [
      "Icon '/usr/share/icons/hicolor/256x256/apps/mytool.png' referenced"
    ];
  };

  badSyntax = testers.testBuildFailure' {
    drv = mkTestDrv "badSyntax";
    expectedBuilderLogEntries = [
      "is not a comment, a group or an entry"
    ];
  };

  badValues = testers.testBuildFailure' {
    drv = mkTestDrv "badValues";
    expectedBuilderLogEntries = [
      "is not a registered type value"
    ];
  };
}
