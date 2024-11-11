{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  clapper,
  gettext,
  gjs,
  glib,
  gobject-introspection,
  gst_all_1,
  gtk4,
  libadwaita,
  makeWrapper,
  meson,
  ninja,
  nodePackages,
  shared-mime-info,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "gnome-shell-extension-hanabi";
  version = "0-unstable-2024-12-01";

  src = fetchFromGitHub {
    owner = "jeffshee";
    repo = "gnome-ext-hanabi";
    rev = "3ed1e3c4e6a533d3f8e5bf38fbf994e6d134f473";
    hash = "sha256-6oW4d2uHl2QfMlZBC2Ih18Hoot3j2g5y0NNc8TCHVpY=";
  };

  passthru = {
    extensionUuid = "hanabi-extension@jeffshee.github.io";
    extensionPortalSlug = "hanabi";
  };

  dontBuild = false;
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    gettext
    glib
    gobject-introspection
    makeWrapper
    meson
    ninja
    nodePackages.nodejs
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    clapper
    gjs
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gtk4
    libadwaita
  ];

  postPatch = ''
    patchShebangs build-aux/meson-postinstall.sh src/renderer/renderer.js
    sed -i 's/"45", "46"/"45", "46", "47"/' src/metadata.json.in
  '';

  postFixup = ''
    mkdir $out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/schemas/
    install -m0755 $src/src/schemas/io.github.jeffshee.hanabi-extension.gschema.xml \
      $out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/schemas/
    install -m0755 $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas/gschemas.compiled \
      $out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/schemas/
    wrapGApp $out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/renderer/renderer.js
  '';

  meta = with lib; {
    description = "Live Wallpaper for GNOME";
    homepage = "https://github.com/jeffshee/gnome-ext-hanabi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ratcornu ];
  };
})
