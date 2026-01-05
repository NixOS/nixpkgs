{
  stdenv,
  lib,
  fetchurl,
  fontconfig,
  glib,
  gnome,
  gnome-desktop,
  gsettings-desktop-schemas,
  gtk4,
  libadwaita,
  libjxl,
  librsvg,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
  webp-pixbuf-loader,
  wrapGAppsHook4,
  xdg-desktop-portal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gnome";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/xdg-desktop-portal-gnome/${lib.versions.major finalAttrs.version}/xdg-desktop-portal-gnome-${finalAttrs.version}.tar.xz";
    hash = "sha256-QB2vzfjLkR8JwI0oE/d03YZBJ6v8qT/0yvH8TJtexNI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    fontconfig
    glib
    gsettings-desktop-schemas # settings exposed by settings portal
    gtk4
    libadwaita
    gnome-desktop
    xdg-desktop-portal
    wayland # required by GTK 4
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  postInstall = ''
    # Pull in WebP and JXL support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          libjxl
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "xdg-desktop-portal-gnome";
    };
  };

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for the GNOME desktop environment";
    homepage = "https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome";
    teams = [ teams.gnome ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
})
