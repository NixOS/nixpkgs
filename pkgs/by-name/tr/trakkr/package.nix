{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  copyDesktopItems,
  bash,
  zenity,
  nodejs_20,
  electron_36,
}:
buildNpmPackage rec {
  pname = "trakkr";
  version = "0.1.7";
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "skybreakdigital";
    repo = "${pname}-app";
    tag = "v${version}";
    hash = "sha256-roL0PVytPPpmkz/6yCvrtaTUhNvqvEh0/uRyPWiJj7I=";
  };

  patches = [
    ./custom_journal_path.patch
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  npmDepsHash = "sha256-qKnyFw2wnSTywKQIFADEAF/D8HsENICjqbSI4yWsZAU=";

  buildPhase = ''
    runHook preBuild

    npm exec vite -- build

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron_36.dist} \
      -c.electronVersion=${electron_36.version} \
      --publish=never

    runHook postBuild
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${src}/public/icon.png $out/share/icons/hicolor/256x256/apps/Trakkr.png
    install -Dm644 ${src}/public/favicon-16x16.png $out/share/icons/hicolor/16x16/apps/Trakkr.png
    install -Dm644 ${src}/public/favicon-32x32.png $out/share/icons/hicolor/32x32/apps/Trakkr.png

    mkdir -p "$out/share/lib/Trakkr"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/Trakkr"
    cp ./dist/index.html "$out/share/lib/Trakkr"

    mkdir -p $out/bin
    cat << EOF > $out/bin/Trakkr
    #!${bash}/bin/bash
    if [[ -n "\$TRAKKR_CUSTOM_JOURNAL_LOCATION" ]] && [[ ! -d "\$TRAKKR_CUSTOM_JOURNAL_LOCATION" ]]; then
      ${zenity}/bin/zenity --error --text="'TRAKKR_CUSTOM_JOURNAL_LOCATION' is set but leads to a non-existent directory!"
      ${zenity}/bin/zenity --info --text="You must enter the live game at least once to generate the journal files."
      exit 1
    fi

    if [[ -z "\$TRAKKR_CUSTOM_JOURNAL_LOCATION" ]] && [[ ! -d "\$HOME/Saved Games/Frontier Developments/Elite Dangerous" ]]; then
      if [[ -d "\$HOME/.local/share/Steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/Saved Games/" ]]; then
        TRAKKR_CUSTOM_JOURNAL_LOCATION="\$HOME/.local/share/Steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/Saved Games/"
      else
        ${zenity}/bin/zenity --error --text="Could not determine the location of journal files!"
        ${zenity}/bin/zenity --info --text="Set the 'TRAKKR_CUSTOM_JOURNAL_LOCATION' environment variable to the correct directory."
        exit 1
      fi
    fi

    # Code relies on checking app.isPackaged, which returns false if the executable is electron.
    # Set ELECTRON_FORCE_IS_PACKAGED=1.
    # https://github.com/electron/electron/issues/35153#issuecomment-1202718531
    export ELECTRON_FORCE_IS_PACKAGED=1

    export TRAKKR_CUSTOM_JOURNAL_LOCATION="\$TRAKKR_CUSTOM_JOURNAL_LOCATION"

    '${electron_36}/bin/electron' $out/share/lib/Trakkr/resources/app.asar \
      \''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} \
      --disable-gpu \
      --disable-gpu-rendering \
      \$@
    EOF

    chmod +x $out/bin/Trakkr

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Trakkr";
      exec = "Trakkr";
      icon = "Trakkr";
      desktopName = "Trakkr";
      categories = [
        "Game"
        "Utility"
      ];
      comment = meta.description;
      terminal = false;
    })
  ];

  meta = {
    description = "Mission tracking tool for Elite: Dangerous";
    longDescription = "Trakkr is specifically designed to assist Elite Dangerous missions, offering tailored support to enhance the efficiency and management of their operations.";
    homepage = "https://github.com/skybreakdigital/trakkr-app";
    changelog = "https://github.com/skybreakdigital/trakkr-app/releases/tag/v${version}";
    mainProgram = "Trakkr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}
