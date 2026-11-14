{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  appstream,
  aria2,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  ffmpeg,
  p7zip,
  deno,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "varia";
  version = "2026.3.27";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "giantpinkrobots";
    repo = "varia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9BH9LL7eSGtjYJKveiJTuC/kWFGmEjNU4qy6JEGpG/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    makeWrapper
    appstream
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    aria2p
    yt-dlp
    emoji-country-flag
    dbus-next
  ];

  postInstall = ''
    rm $out/bin/varia
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapper "$out/bin/varia-py.py" "$out/bin/varia" \
      ''${gappsWrapperArgs[@]} \
      --prefix PATH : ${
        lib.makeBinPath [
          aria2
          ffmpeg
          p7zip
          deno
        ]
      } \
      --add-flags "${lib.getExe aria2}" \
      --add-flags "${lib.getExe ffmpeg}" \
      --add-flags "${lib.getExe p7zip}" \
      --add-flags "deno" \
      --add-flags "${lib.getExe deno}" \
      --add-flags "NOSNAP"
  '';

  meta = {
    description = "Simple download manager based on aria2 and libadwaita";
    homepage = "https://giantpinkrobots.github.io/varia";
    license = lib.licenses.mpl20;
    mainProgram = "varia";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
