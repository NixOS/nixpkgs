{ stdenv
, lib
, fetchFromGitHub
, glib
, gobject-introspection
, intltool
, shared-mime-info
, gtk3
, wrapGAppsHook
, libxml2
, xapps
, meson
, pkg-config
, cairo
, libsecret
, poppler
, libspectre
, libgxps
, webkitgtk
, nodePackages
, ninja
, gsettings-desktop-schemas
, djvulibre
, backends ? [ "pdf" "ps" /* "dvi" "t1lib" */ "djvu" "tiff" "pixbuf" "comics" "xps" "epub" ]
}:

stdenv.mkDerivation rec {
  pname = "xreader";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-wBrP5SHGPvH/Gz9QY253zQuf8WSjV19oNB5aIqXGLZ8=";
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
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ] ++ (map (x: "-D${x}=true") backends);

  buildInputs = [
    glib
    gtk3
    xapps
    cairo
    libxml2
    libsecret
    poppler
    libspectre
    libgxps
    webkitgtk
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
