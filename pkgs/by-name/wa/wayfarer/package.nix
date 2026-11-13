{
  lib,
  stdenv,
  fetchFromCodeberg,
  blueprint-compiler,
  desktop-file-utils,
  gst_all_1,
  gtk4,
  libpulseaudio,
  meson,
  ninja,
  pipewire,
  pkg-config,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfarer";
  version = "1.4.0";

  src = fetchFromCodeberg {
    owner = "stronnag";
    repo = "wayfarer";
    tag = finalAttrs.version;
    hash = "sha256-+DKPRZjJ2Gg2TdoTk8LFsQlI3ecitLOGouVFEexwjkQ=";
  };

  postPatch = ''
    patchShebangs src/getinfo.sh

    # OS release information is not available in the sandbox
    substituteInPlace meson/baseinfo.py \
      --replace-warn 'platform.freedesktop_os_release()["NAME"]' '"NixOS"'
  '';

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-ugly
    gtk4
    libpulseaudio
    pipewire
  ];

  meta = {
    description = "Screen recorder for GNOME / Wayland / pipewire";
    homepage = "https://codeberg.org/stronnag/wayfarer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "wayfarer";
    platforms = lib.subtractLists lib.platforms.darwin lib.platforms.unix;
  };
})
