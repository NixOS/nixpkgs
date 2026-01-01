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
<<<<<<< HEAD
  mathjax,
=======
  nodePackages,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "4.6.1";
=======
  version = "4.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xreader";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-+T89KxGTGycN1pnXBxJY15ViRvwJbM2adZVUTTSG3VQ=";
=======
    hash = "sha256-cp/pZ42AS98AD78BVMeY3SHQHkYA2h4o0kddr/H+kUA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    # FIXME: `MathJax.js` is only available in MathJax 2.7.x.
    "-Dmathjax-directory=${mathjax}"
=======
    "-Dmathjax-directory=${nodePackages.mathjax}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    mathjax
=======
    nodePackages.mathjax
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    djvulibre
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

<<<<<<< HEAD
  meta = {
    description = "Document viewer capable of displaying multiple and single page
document formats like PDF and Postscript";
    homepage = "https://github.com/linuxmint/xreader";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    description = "Document viewer capable of displaying multiple and single page
document formats like PDF and Postscript";
    homepage = "https://github.com/linuxmint/xreader";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
