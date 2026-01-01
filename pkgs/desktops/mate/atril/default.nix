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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "atril";
  version = "1.28.3";
=======
stdenv.mkDerivation rec {
  pname = "atril";
  version = "1.28.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "atril";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-y+J/goOl5ol3j0ySLkyQSndS8zc+dOKhyrPv0FmVkZg=";
=======
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-NnWD3Gcxn8ZZKdHzg6iclLiSwj3sBvF+BwpNtcU+dSY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    ++ lib.optionals enableEpub [
      # FIXME: We ship this with non-existent fallback mathjax-directory
      # because `MathJax.js` is only available in MathJax 2.7.x.
      "--enable-epub"
    ]
=======
    ++ lib.optionals enableEpub [ "--enable-epub" ]
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  meta = with lib; {
    description = "Simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
