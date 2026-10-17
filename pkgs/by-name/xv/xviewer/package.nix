{
  stdenv,
  lib,
  fetchFromGitHub,
  docbook_xsl,
  exempi,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  gtk-doc,
  itstool,
  lcms2,
  libexif,
  libjpeg,
  libpeas,
  librsvg,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook3,
  cinnamon-desktop,
  yelp-tools,
  xapp,
  xapp-symbolic-icons,
  gnome,
  libavif,
  libheif,
  libjxl,
  webp-pixbuf-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xviewer";
  version = "3.4.17";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xviewer";
    rev = finalAttrs.version;
    hash = "sha256-U6p79pgiXdCLLnLZ4h3fvXj9UXG0atBccoBXGvAM5Yo=";
  };

  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    gtk-doc
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    cinnamon-desktop
    exempi
    gdk-pixbuf
    glib
    gtk3
    lcms2
    libexif
    libjpeg
    libpeas
    librsvg
    libxml2
    xapp
  ];

  postInstall = ''
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          libavif
          libheif.lib
          libjxl
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = {
    description = "Generic image viewer from Linux Mint";
    mainProgram = "xviewer";
    homepage = "https://github.com/linuxmint/xviewer";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tu-maurice ];
    teams = [ lib.teams.cinnamon ];
  };
})
