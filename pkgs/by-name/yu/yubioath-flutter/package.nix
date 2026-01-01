{
  lib,
  flutter335,
<<<<<<< HEAD
  python3Packages,
=======
  python3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  pcre2,
  libnotify,
  libappindicator,
<<<<<<< HEAD
  gnome-screenshot,
  removeReferencesTo,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
=======
  pkg-config,
  gnome-screenshot,
  makeWrapper,
  removeReferencesTo,
  runCommand,
  yq,
  yubioath-flutter,
  _experimental-update-script-combinators,
  gitUpdater,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

flutter335.buildFlutterApplication rec {
  pname = "yubioath-flutter";
<<<<<<< HEAD
  version = "7.3.1";
=======
  version = "7.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jfWLj5pN1NGfnmYQ0lYeKwlc0v7pCdvAjmmWX5GP7aM=";
=======
    hash = "sha256-1Hr8ZDHXiLiYfQg4PEpmIuIJR/USbsGCgI4YZSex2Eg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.window_manager = "sha256-WKcNwEOthXj1S2lKlpdhy+r8JZslVqhwY2ywXeTSBEs=";

  postPatch = ''
    rm -f pubspec.lock

    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "../build/linux/helper" "${passthru.helper}/libexec/helper"
  '';

<<<<<<< HEAD
  nativeBuildInputs = [ removeReferencesTo ];
=======
  nativeBuildInputs = [
    makeWrapper
    removeReferencesTo
    pkg-config
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    helper = python3Packages.callPackage ./helper.nix { inherit src version meta; };
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { extraArgs = [ "--use-github-releases" ]; })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "yubioath-flutter.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
