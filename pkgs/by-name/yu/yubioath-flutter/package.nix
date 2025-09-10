{
  lib,
  flutter332,
  python3,
  fetchFromGitHub,
  pcre2,
  libnotify,
  libappindicator,
  pkg-config,
  gnome-screenshot,
  makeWrapper,
  removeReferencesTo,
  runCommand,
  yq,
  yubioath-flutter,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter332.buildFlutterApplication rec {
  pname = "yubioath-flutter";
  version = "7.2.3";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    tag = version;
    hash = "sha256-n7BfstsuOTv8d16Y5oE/LDqlj0nVs/6196SnLaLN7h4=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.window_manager = "sha256-WKcNwEOthXj1S2lKlpdhy+r8JZslVqhwY2ywXeTSBEs=";

  postPatch = ''
    rm -f pubspec.lock

    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "../build/linux/helper" "${passthru.helper}/libexec/helper"
  '';

  nativeBuildInputs = [
    makeWrapper
    removeReferencesTo
    pkg-config
  ];

  buildInputs = [
    pcre2
    libnotify
    libappindicator
  ];

  preInstall = ''
    # Make sure we have permission to delete things CMake has copied in to our build directory from elsewhere.
    chmod -R +w build
  '';

  postInstall = ''
    # Swap the authenticator-helper symlink with the correct symlink.
    ln -fs "${passthru.helper}/bin/authenticator-helper" "$out/app/$pname/helper/authenticator-helper"

    # Move the icon.
    mkdir $out/share/pixmaps
    mv $out/app/$pname/linux_support/com.yubico.yubioath.png $out/share/pixmaps

    # Cleanup.
    rm -rf \
      "$out/app/$pname/README.adoc" \
      "$out/app/$pname/desktop_integration.sh" \
      "$out/app/$pname/linux_support" \
      $out/bin/* # We will repopulate this directory later.

    # Symlink binary.
    ln -sf "$out/app/$pname/authenticator" "$out/bin/yubioath-flutter"

    # Set the correct path to the binary in desktop file.
    substituteInPlace "$out/share/applications/com.yubico.yubioath.desktop" \
      --replace-fail '"@EXEC_PATH/authenticator"' "yubioath-flutter" \
      --replace-fail "@EXEC_PATH/linux_support/com.yubico.yubioath.png" "com.yubico.yubioath"
  '';

  # Needed for QR scanning to work
  extraWrapProgramArgs = ''
    --prefix PATH : ${lib.makeBinPath [ gnome-screenshot ]}
  '';

  passthru = {
    helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (yubioath-flutter) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { })
      (_experimental-update-script-combinators.copyAttrOutputToFile "yubioath-flutter.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Yubico Authenticator for Desktop";
    mainProgram = "yubioath-flutter";
    homepage = "https://github.com/Yubico/yubioath-flutter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
