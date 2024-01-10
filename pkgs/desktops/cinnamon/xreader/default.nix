{ stdenv
, lib
, fetchFromGitHub
, glib
, gobject-introspection
, intltool
, shared-mime-info
, gtk3
, wrapGAppsHook
, libarchive
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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-sADdslxDtI+zV8DLnczlzNtB9W+BhMP8vb5riSnPYaw=";
  };

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
    libarchive
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
