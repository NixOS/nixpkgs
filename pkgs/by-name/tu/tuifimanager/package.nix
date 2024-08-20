{ stdenv
, lib
, python3
, fetchFromGitHub
, kdePackages
, gnome-themes-extra
, qt6
, makeWrapper
, x11Support ? stdenv.isLinux
# pypinput is marked as broken for darwin
, pynputSupport ? stdenv.isLinux
# Experimental Drag & Drop support requires x11 & pyinput suport
, hasDndSupport ? x11Support && pynputSupport
, enableDragAndDrop ? false
}:

lib.throwIf (enableDragAndDrop && !hasDndSupport)
  "Drag and drop support is only available for linux with xorg."

python3.pkgs.buildPythonApplication rec {
  pname = "tuifimanager";
  version = "4.1.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "GiorgosXou";
    repo = "TUIFIManager";
    rev = "v.${version}";
    hash = "sha256-kljodLSSjvGcjhD7IhAVAAGd6LoiM6IYwMXuSsIJ198=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ] ++ (lib.optionals enableDragAndDrop [
    qt6.wrapQtAppsHook
    makeWrapper
  ]);

  propagatedBuildInputs = [
    python3.pkgs.send2trash
    python3.pkgs.unicurses
  ] ++ (lib.optionals enableDragAndDrop [
    python3.pkgs.pynput
    python3.pkgs.pyside6
    python3.pkgs.requests
    python3.pkgs.xlib
    kdePackages.qtbase
    kdePackages.qt6gtk2
  ]);

  postFixup = let
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
    maintainers = with lib.maintainers; [ michaelBelsanti sigmanificient ];
    mainProgram = "tuifi";
  };
}
