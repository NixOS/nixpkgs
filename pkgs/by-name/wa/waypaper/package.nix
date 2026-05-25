{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  killall,
  socat,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "waypaper";
  version = "2.7-unstable-2026-01-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "waypaper";
    rev = "17f60be4c6abc5ab9c5d4837d930015661ccdd3d";
    hash = "sha256-HkWsffcK/FjXeyzp948xhvMbrdrBcGwkuTI9O16OWbo=";
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

  propagatedBuildInputs = [
    killall
    socat
  ];

  # has no tests
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    changelog = "https://github.com/anufrievroman/waypaper/releases/tag/${finalAttrs.version}";
    description = "GUI wallpaper setter for Wayland-based window managers";
    mainProgram = "waypaper";
    longDescription = ''
      GUI wallpaper setter for Wayland-based window managers that works as a frontend for popular backends like swaybg and swww.

      If wallpaper does not change, make sure that swaybg or swww is installed.
    '';
    homepage = "https://github.com/anufrievroman/waypaper";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      prince213
      totalchaos
    ];
    platforms = lib.platforms.linux;
  };
})
