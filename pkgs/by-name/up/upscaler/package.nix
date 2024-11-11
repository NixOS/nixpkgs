{ lib
, python3Packages
, fetchFromGitLab
, upscayl-ncnn
, meson
, ninja
, pkg-config
, gobject-introspection
, blueprint-compiler
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
}:

python3Packages.buildPythonApplication rec {
  pname = "upscaler";
  version = "1.4.0";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Upscaler";
    rev = "refs/tags/${version}";
    hash = "sha256-Dy8tykIbK5o0XulurG+TxORZZSxfRe5Kjh6aGpsh+0Y=";
  };

  postPatch = ''
    substituteInPlace upscaler/window.py \
      --replace-fail '"upscayl-bin",' '"${lib.getExe upscayl-ncnn}",'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
    vulkan
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "GTK4+libadwaita application that allows you to upscale and enhance a given image";
    homepage = "https://tesk.page/upscaler";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "upscaler";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
