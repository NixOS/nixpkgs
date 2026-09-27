{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  glib,
  gobject-introspection,
  intltool,
  shared-mime-info,
  gtk3,
  wrapGAppsHook3,
  libarchive,
  libxml2,
  xapp,
  xapp-symbolic-icons,
  meson,
  pkg-config,
  cairo,
  libsecret,
  poppler,
  libspectre,
  libgxps,
  webkitgtk_4_1,
  mathjax,
  ninja,
  djvulibre,
  backends ? [
    "pdf"
    "ps" # "dvi" "t1lib"
    "djvu"
    "tiff"
    "pixbuf"
    "comics"
    "xps"
    "epub"
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xreader";
  version = "4.6.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xreader";
    rev = finalAttrs.version;
    hash = "sha256-wycQmScxuSlo6Ln6piSBF7kmzvi6FnTm/ES/Ds+/h8I=";
  };

  patches = [
    # ev-poppler.cc: Only read a link destination for GOTO_DEST
    # Fixes CVE-2026-19772
    (fetchpatch {
      url = "https://github.com/linuxmint/xreader/commit/28ee72cc2779a3716b7d00da1aa87da992648d24.patch";
      hash = "sha256-pd0kyfwsph+H9lii7CfndETsKTYSWyYw2tb9bMOHRX8=";
    })
  ];

  nativeBuildInputs = [
    shared-mime-info
    wrapGAppsHook3
    meson
    ninja
    pkg-config
    gobject-introspection
    intltool
  ];

  mesonFlags = [
    # FIXME: `MathJax.js` is only available in MathJax 2.7.x.
    "-Dmathjax-directory=${mathjax}"
    "-Dintrospection=true"
  ]
  ++ (map (x: "-D${x}=true") backends);

  buildInputs = [
    glib
    gtk3
    xapp
    cairo
    libarchive
    libxml2
    libsecret
    poppler
    libspectre
    libgxps
    webkitgtk_4_1
    mathjax
    djvulibre
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = {
    description = "Document viewer capable of displaying multiple and single page
document formats like PDF and Postscript";
    homepage = "https://github.com/linuxmint/xreader";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
