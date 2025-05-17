{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  killall,
}:

python3Packages.buildPythonApplication rec {
  pname = "waypaper";
  version = "2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "waypaper";
    tag = version;
    hash = "sha256-MGfTuQcVChI4g7RONiTZZ4a5uX5SDjfLeMxbLIZ7VH4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    imageio
    imageio-ffmpeg
    pillow
    platformdirs
    pygobject3
    screeninfo
  ];

  propagatedBuildInputs = [ killall ];

  # has no tests
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    changelog = "https://github.com/anufrievroman/waypaper/releases/tag/${version}";
    description = "GUI wallpaper setter for Wayland-based window managers";
    mainProgram = "waypaper";
    longDescription = ''
      GUI wallpaper setter for Wayland-based window managers that works as a frontend for popular backends like swaybg and swww.

      If wallpaper does not change, make sure that swaybg or swww is installed.
    '';
    homepage = "https://github.com/anufrievroman/waypaper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      prince213
      totalchaos
    ];
    platforms = platforms.linux;
  };
}
