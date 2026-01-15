{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  gtk-doc,
  gettext,
  yelp-tools,
  caja,
  gtk3,
  glib,
  libxml2,
  libarchive,
  libsecret,
  poppler,
  mate-desktop,
  itstool,
  hicolor-icon-theme,
  texlive,
  wrapGAppsHook3,
  enableEpub ? true,
  webkitgtk_4_1,
  enableDjvu ? true,
  djvulibre,
  enablePostScript ? true,
  libspectre,
  enableXps ? true,
  libgxps,
  enableImages ? false,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atril";
  version = "1.28.3";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "atril";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-y+J/goOl5ol3j0ySLkyQSndS8zc+dOKhyrPv0FmVkZg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    itstool
    pkg-config
    gettext
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    caja
    gtk3
    glib
    libarchive
    libsecret
    libxml2
    poppler
    mate-desktop
    hicolor-icon-theme
    texlive.bin.core # for synctex, used by the pdf back-end
  ]
  ++ lib.optionals enableDjvu [ djvulibre ]
  ++ lib.optionals enableEpub [ webkitgtk_4_1 ]
  ++ lib.optionals enablePostScript [ libspectre ]
  ++ lib.optionals enableXps [ libgxps ];

  configureFlags =
    [ ]
    ++ lib.optionals enableDjvu [ "--enable-djvu" ]
    ++ lib.optionals enableEpub [
      # FIXME: We ship this with non-existent fallback mathjax-directory
      # because `MathJax.js` is only available in MathJax 2.7.x.
      "--enable-epub"
    ]
    ++ lib.optionals enablePostScript [ "--enable-ps" ]
    ++ lib.optionals enableXps [ "--enable-xps" ]
    ++ lib.optionals enableImages [ "--enable-pixbuf" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [ "cajaextensiondir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    odd-unstable = true;
  };

  meta = {
    description = "Simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
