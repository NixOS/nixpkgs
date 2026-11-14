{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  glib,
  webkitgtk_4_1,
  gst_all_1,
  ffmpeg,
  gpu-screen-recorder,
  wf-recorder,
  pulseaudio,
  alsa-utils,
  wl-clipboard,
  xclip,
  xsel,
  xdg-utils,
  xdotool,
  xprop,
  xrandr,
  xdpyinfo,
  wmctrl,
  cloudflared,
  systemd,
  desktop-file-utils,
  udevCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "vice";
  version = "2.10.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eklonofficial";
    repo = "Vice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+ahNY4ckW0WBqE2Kg1uxmRpY+hCc/5E5+rbMq3fbwE=";
  };

  patches = [
    # Look for vice.service on XDG_DATA_DIRS as upstream only looks in /usr/lib and would report it missing
    ./find-systemd-service-in-xdg-data-dirs.patch
    # Unpack each alias tuple and check each name separately because some evdev key names are a tuple of
    # aliases instead of a string but vice can only process strings so it crashes
    ./support-evdev-key-aliases.patch
  ];

  build-system = [ python3Packages.setuptools ];

  postPatch = ''
    # Restrict raw access to keyboards as Vice only needs hotkeys and upstream grants it to every input device
    substituteInPlace packaging/vice.rules \
      --replace-fail \
        'KERNEL=="event*", SUBSYSTEM=="input", TAG+="uaccess"' \
        'KERNEL=="event*", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", TAG+="uaccess"'
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
    webkitgtk_4_1
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  dependencies = with python3Packages; [
    aiohttp
    click
    evdev
    psutil
    pygobject3
    pywebview
    tomli-w
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          gpu-screen-recorder
          wf-recorder
          pulseaudio
          alsa-utils
          wl-clipboard
          xclip
          xsel
          xdg-utils
          xdotool
          xprop
          xrandr
          xdpyinfo
          wmctrl
          cloudflared
          systemd
        ]
      }
    )
  '';

  postInstall = ''
    install -Dm644 vice.desktop $out/share/applications/vice.desktop
    install -Dm644 assets/vice.svg $out/share/icons/hicolor/scalable/apps/vice.svg
    install -Dm644 packaging/vice.rules $out/lib/udev/rules.d/70-vice-input.rules
    install -Dm644 packaging/vice.service $out/lib/systemd/user/vice.service
    substituteInPlace $out/lib/systemd/user/vice.service \
      --replace-fail /usr/bin/vice $out/bin/vice
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    udevCheckHook
    desktop-file-utils
    ffmpeg
  ];

  doCheck = true;
  doInstallCheck = true;

  preCheck = ''
    rm -rf build
  '';

  postInstallCheck = ''
    desktop-file-validate $out/share/applications/vice.desktop
  '';

  pythonImportsCheck = [
    "vice.main"
    "vice.app"
    "vice.editor"
    "vice.hotkey"
    "vice.playlists"
    "vice.recorder"
    "vice.runtime"
    "vice.share"
    "vice.updates"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux game clip recorder, like Medal.tv, for Wayland and X11";
    homepage = "https://github.com/eklonofficial/Vice";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "vice";
    platforms = lib.platforms.linux;
  };
})
