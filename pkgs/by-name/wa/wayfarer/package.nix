{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "1.2.4-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "stronnag";
    repo = "wayfarer";
    # branch development - has new gtk4 code
    rev = "2517004bb3c48653100f0c6a6da16fde7927755e";
    hash = "sha256-ULmkjyBuqVwsFbLOdvqxvsAH1EF7zXFEBhU//nsV5sU=";
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

  meta = with lib; {
    description = "Screen recorder for GNOME / Wayland / pipewire";
    homepage = "https://github.com/stronnag/wayfarer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "wayfarer";
    platforms = subtractLists platforms.darwin platforms.unix;
  };
})
