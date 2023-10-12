{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, glib
, gobject-introspection
, intltool
, shared-mime-info
, gtk3
, wrapGAppsHook
, libxml2
, xapp
, meson
, pkg-config
, cairo
, libsecret
, poppler
, libspectre
, libgxps
, webkitgtk_4_1
, nodePackages
, ninja
, gsettings-desktop-schemas
, djvulibre
, backends ? [ "pdf" "ps" /* "dvi" "t1lib" */ "djvu" "tiff" "pixbuf" "comics" "xps" "epub" ]
}:

stdenv.mkDerivation rec {
  pname = "xreader";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-2zqlfoN4L+V237cQ3PVh49YaZfNKGiLqh2JIiGJE340=";
  };

  patches = [
    # Fix build with meson 1.2, can be dropped on next bump
    # https://github.com/linuxmint/xreader/issues/612
    (fetchpatch {
      url = "https://github.com/linuxmint/xreader/commit/06b18a884c8cf3257ea1f053a82784da078999ed.patch";
      sha256 = "sha256-+LXEW3OkfhkIcbxtvfQYjdaC18O8imOx22t91ad/XZw=";
    })
  ];

  nativeBuildInputs = [
    shared-mime-info
    wrapGAppsHook
    meson
    ninja
    pkg-config
    gobject-introspection
    intltool
  ];

  mesonFlags = [
    "-Dmathjax-directory=${nodePackages.mathjax}"
  ] ++ (map (x: "-D${x}=true") backends);

  buildInputs = [
    glib
    gtk3
    xapp
    cairo
    libxml2
    libsecret
    poppler
    libspectre
    libgxps
    webkitgtk_4_1
    nodePackages.mathjax
    djvulibre
  ];

  meta = with lib; {
    description = "A document viewer capable of displaying multiple and single page
document formats like PDF and Postscript";
    homepage = "https://github.com/linuxmint/xreader";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
