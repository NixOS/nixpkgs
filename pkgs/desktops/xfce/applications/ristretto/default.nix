{ lib
, mkXfceDerivation
, gtk3
, glib
, gnome
, libexif
, libjxl
, librsvg
, libxfce4ui
, libxfce4util
, webp-pixbuf-loader
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.13.2";
  odd-unstable = false;

  sha256 = "sha256-FKgNKQ2l4FGvEvmppf+RTxMXU6TfsZVFBVii4zr4ASc=";

  buildInputs = [
    glib
    gtk3
    libexif
    libxfce4ui
    libxfce4util
    xfconf
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  postInstall = ''
    # Pull in JXL and WebP support for ristretto.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        libjxl
        librsvg
        webp-pixbuf-loader
      ];
    }}"
  '';

  meta = with lib; {
    description = "Fast and lightweight picture-viewer for the Xfce desktop environment";
    mainProgram = "ristretto";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
