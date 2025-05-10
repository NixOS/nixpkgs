{
  stdenv,
  lib,
  fetchFromGitHub,

  glib,
  appstream,
  gobject-introspection,
  shared-mime-info,
  gst_all_1,
  gjs,
  wrapGAppsHook4,
  gtk4,

  meson,
  ninja,

  clapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-ext-hanabi";
  version = "1-unstable-2025-04-06";
  dontWrapGApps = true;

  src = fetchFromGitHub {
    owner = "jeffshee";
    repo = "gnome-ext-hanabi";
    rev = "cb0d46d67146a9824893047d83852897aae582fc";
    hash = "sha256-9hlIXRCj3kwHP5xn1kJ4Wb6yUoFz6G73yhUh3M4xvaU=";
  };

  /*
    This extension is NOT uploaded to extensions.gnome.org

    This means it has to be manually packaged
  */

  nativeBuildInputs = [
    meson
    ninja
    glib
    wrapGAppsHook4
    gobject-introspection # Do I need this? I don't know
    shared-mime-info # Do I need this? I don't know
  ];

  buildInputs = [
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi

    gtk4
    clapper
    gjs
  ];

  /*
    From the repo:

    ##Optimization

    Hanabi extension can utilize clappersink from Clapper for the best performance if installed.

    For this to work, Clapper must be installed from the package manager and not from Flatpak/Snap.
  */

  postPatch = ''
    patchShebangs build-aux/meson-postinstall.sh
  '';

  postFixup = ''
    wrapGApp "$out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/renderer/renderer.js"
    ln -s "$out/share/gsettings-schemas/${finalAttrs.pname}-${finalAttrs.version}/glib-2.0/schemas" "$out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/schemas"
  '';

  passthru = {
    extensionUuid = "hanabi-extension@jeffshee.github.io";
    extensionPortalSlug = "hanabi";
  };

  meta = {
    description = "Live Wallpaper for GNOME";
    homepage = "https://github.com/jeffshee/gnome-ext-hanabi";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hustlerone ];
    platforms = lib.platforms.linux;
  };
})
