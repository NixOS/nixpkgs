{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  cairo,
  exo,
  gtk3,
  libexif,
  libxfce4ui,
  libxfce4util,
  xfconf,
  gnome,
  libheif,
  libjxl,
  librsvg,
  webp-pixbuf-loader,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ristretto";
  version = "0.13.4";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "ristretto";
    tag = "ristretto-${finalAttrs.version}";
    hash = "sha256-X0liZddeEOxlo0tyn3Irvo0+MTnMFuvKY2m4h+/EI2E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    exo
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
          libheif.lib
          libjxl
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "ristretto-"; };

  meta = {
    description = "Fast and lightweight picture-viewer for the Xfce desktop environment";
    homepage = "https://gitlab.xfce.org/apps/ristretto";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ristretto";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
