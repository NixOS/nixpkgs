{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  kdePackages,
  gnome-themes-extra,
  qt6,
  makeWrapper,
  x11Support ? stdenv.hostPlatform.isLinux,
  # pypinput is marked as broken for darwin
  pynputSupport ? stdenv.hostPlatform.isLinux,
  # Experimental Drag & Drop support requires x11 & pyinput support
  hasDndSupport ? x11Support && pynputSupport,
  enableDragAndDrop ? false,
}:

lib.throwIf (enableDragAndDrop && !hasDndSupport)
  "Drag and drop support is only available for linux with xorg."

  python3Packages.buildPythonApplication
  rec {
    pname = "tuifimanager";
    version = "5.1.5";

    pyproject = true;

    src = fetchFromGitHub {
      owner = "GiorgosXou";
      repo = "TUIFIManager";
      tag = "v.${version}";
      hash = "sha256-5ShrmjEFKGdmaGBFjMnIfcM6p8AZd13uIEFwDVAkU/8=";
    };

    build-system = with python3Packages; [
      setuptools
      setuptools-scm
    ];

    nativeBuildInputs =
      [ ]
      ++ (lib.optionals enableDragAndDrop [
        qt6.wrapQtAppsHook
        makeWrapper
      ]);

    dependencies = [
      python3Packages.send2trash
      python3Packages.unicurses
    ]
    ++ (lib.optionals enableDragAndDrop [
      python3Packages.pynput
      python3Packages.pyside6
      python3Packages.requests
      python3Packages.xlib
      kdePackages.qtbase
      kdePackages.qt6gtk2
    ]);

    postFixup =
      let
        # fix missing 'adwaita' warning missing with ncurses tui
        # see: https://github.com/NixOS/nixpkgs/issues/60918
        theme = gnome-themes-extra;
      in
      lib.optionalString enableDragAndDrop ''
        wrapProgram $out/bin/tuifi \
          --prefix GTK_PATH : "${theme}/lib/gtk-2.0" \
          --set tuifi_synth_dnd True
      '';

    pythonImportsCheck = [ "TUIFIManager" ];

    meta = {
      description = "Cross-platform terminal-based termux-oriented file manager";
      longDescription = ''
        A cross-platform terminal-based termux-oriented file manager (and component),
        meant to be used with a Uni-Curses project or as is. This project is mainly an
        attempt to get more attention to the Uni-Curses project.
      '';
      homepage = "https://github.com/GiorgosXou/TUIFIManager";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        michaelBelsanti
        sigmanificient
      ];
      mainProgram = "tuifi";
    };
  }
