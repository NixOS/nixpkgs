{
  stdenv,
  lib,
  fetchFromGitHub,
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

stdenv.mkDerivation rec {
  pname = "xreader";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xreader";
    rev = version;
    hash = "sha256-+T89KxGTGycN1pnXBxJY15ViRvwJbM2adZVUTTSG3VQ=";
  };

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
}
