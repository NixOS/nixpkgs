{ stdenv, gettext, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, libxslt, webkitgtk
, gnome3, librsvg, gdk_pixbuf, libsoup, docbook_xsl
, gobjectIntrospection, json-glib, inkscape, poppler_utils
, gmp, desktop-file-utils, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-documents-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0q7bp0mvmhqmsvm5sjavm46y7sz43na62d1hrl62vg19hdqr9ir4";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-documents"; attrPath = "gnome3.gnome-documents"; };
  };

  doCheck = true;

  configureFlags = [ "--enable-getting-started" ];

  nativeBuildInputs = [ pkgconfig gettext itstool libxslt desktop-file-utils docbook_xsl wrapGAppsHook ];
  buildInputs = [ gtk3 glib inkscape poppler_utils
                  gnome3.gsettings-desktop-schemas gmp
                  gdk_pixbuf gnome3.defaultIconTheme librsvg evince
                  libsoup webkitgtk gjs gobjectIntrospection gnome3.rest
                  tracker tracker-miners gnome3.libgdata gnome3.gnome-online-accounts
                  gnome3.gnome-desktop gnome3.libzapojit json-glib gnome3.libgepub ];

  enableParallelBuilding = true;

  preFixup = ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib.dev}/bin/gapplication"

    gappsWrapperArgs+=(--run 'if [ -z "$XDG_CACHE_DIR" ]; then XDG_CACHE_DIR=$HOME/.cache; fi; if [ -w "$XDG_CACHE_DIR/.." ]; then mkdir -p "$XDG_CACHE_DIR/gnome-documents"; fi')
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Documents;
    description = "Document manager application designed to work with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
