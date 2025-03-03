{
  lib,
  mkXfceDerivation,
  gtk3,
  glib,
  gnome,
  libexif,
  libheif,
  libjxl,
  librsvg,
  libxfce4ui,
  libxfce4util,
  webp-pixbuf-loader,
  xfconf,
}:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.13.3";
  odd-unstable = false;

  sha256 = "sha256-cJMHRN4Wl6Fm0yoVqe0h30ZUlE1+Hw1uEDBHfHXBbC0=";

  buildInputs = [
    glib
    gtk3
    libexif
    libxfce4ui
    libxfce4util
    xfconf
  ];

  postInstall = ''
    # Pull in HEIF, JXL and WebP support for ristretto.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          libheif.out
          libjxl
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  meta = with lib; {
    description = "Fast and lightweight picture-viewer for the Xfce desktop environment";
    mainProgram = "ristretto";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
