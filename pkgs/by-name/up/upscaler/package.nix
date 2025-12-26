{
  lib,
  fetchFromGitLab,
  glib,
  gtk4,
  meson,
  ninja,
  gitUpdater,
  desktop-file-utils,
  appstream,
  blueprint-compiler,
  python3Packages,
  pkg-config,
  libadwaita,
  wrapGAppsHook4,
  upscayl-ncnn,
}:

python3Packages.buildPythonApplication rec {
  pname = "upscaler";
  version = "1.6.2";

  pyproject = false; # meson instead of pyproject

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Upscaler";
    rev = version;
    hash = "sha256-Mt0bFPidg0/bxd3NP+1jVgWzRemaGKlU/l5orKbziB0=";
  };

  passthru.updateScript = gitUpdater { };

  postPatch = ''
    substituteInPlace upscaler/window.py \
      --replace-fail '"upscayl-bin",' '"${lib.getExe upscayl-ncnn}",'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    wrapGAppsHook4
    meson
    ninja
    desktop-file-utils
    appstream
    blueprint-compiler
    pkg-config
    gtk4
    glib
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
    vulkan
  ];

  buildInputs = [
    libadwaita
    upscayl-ncnn
  ];

  mesonFlags = [
    (lib.mesonBool "network_tests" false)
  ];

  # NOTE: `postCheck` is intentionally not used here, as the entire checkPhase
  # is skipped by `buildPythonApplication`
  # https://github.com/NixOS/nixpkgs/blob/9d4343b7b27a3e6f08fc22ead568233ff24bbbde/pkgs/development/interpreters/python/mk-python-derivation.nix#L296
  postInstallCheck = ''
    mesonCheckPhase
  '';

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Upscale and enhance images";
    homepage = "https://tesk.page/upscaler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      grimmauld
      getchoo
      aleksana
    ];
    mainProgram = "upscaler";
    platforms = lib.platforms.linux;
  };
}
