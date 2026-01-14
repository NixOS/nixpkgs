{
  lib,
  python3Packages,
  fetchFromGitHub,
  libxslt,
  gobject-introspection,
  gtk3,
  wrapGAppsHook3,
  adwaita-icon-theme,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "wpgtk";
  version = "6.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deviantfero";
    repo = "wpgtk";
    tag = version;
    hash = "sha256-X7KKXPNKqs0pVRrR04ZrJgCTDZUj3lcFKnwSaX4/RAM=";
  };

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    writableTmpDirAsHomeHook # The $HOME variable must be set to build the package. A "permission denied" error will occur otherwise
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
    libxslt
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
    pywal
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  # No test exist
  doCheck = false;

  meta = {
    description = "Template based wallpaper/colorscheme generator and manager";
    longDescription = ''
      In short, wpgtk is a colorscheme/wallpaper manager with a template system attached which lets you create templates from any textfile and will replace keywords on it on the fly, allowing for great styling and theming possibilities.

      wpgtk uses pywal as its colorscheme generator, but builds upon it with a UI and other features, such as the abilty to mix and edit the colorschemes generated and save them with their respective wallpapers, having light and dark themes, hackable and fast GTK theme made specifically for wpgtk and custom keywords and values to replace in templates.

      INFO: To work properly, this tool needs "programs.dconf.enable = true" on nixos or dconf installed. A reboot may be required after installing dconf.
    '';
    homepage = "https://github.com/deviantfero/wpgtk";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      melkor333
      cafkafk
    ];
    mainProgram = "wpg";
  };
}
