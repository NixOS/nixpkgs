{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  wrapGAppsHook4,
  gobject-introspection,
  gettext,
  python3Packages,
  pkg-config,
  glib,
  gtk4,
  libadwaita,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "whisp";
  version = "1.3.8";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "tanaybhomia";
    repo = "whisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OzD8Htha/BhOGiTgq42ZEIUZIywy4VK61zqiaBPaFbc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection
    gettext
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  pythonPath = with python3Packages; [
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "The Anti-Note for GNOME";
    longDescription = ''
      The Anti-Note for GNOME.
      A fluid, gesture-driven scratchpad designed for absolute speed.
    '';
    homepage = "https://tanaybhomia.github.io/Whisp/";
    license = lib.licenses.gpl3;
    mainProgram = "whisp";
    maintainers = [ lib.maintainers.luminarleaf ];
    platforms = lib.platforms.linux;
  };
})
