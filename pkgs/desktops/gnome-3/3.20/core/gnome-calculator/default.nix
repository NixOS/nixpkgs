{ stdenv, intltool, fetchurl, pkgconfig, libxml2
, bash, gtk3, glib, wrapGAppsHook
, itstool, gnome3, librsvg, gdk_pixbuf, mpfr, gmp, libsoup }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  # Fix for  https://github.com/NixOS/nixpkgs/issues/17912
  # See also https://bugzilla.gnome.org/show_bug.cgi?id=673101
  # Should be removed when next release comes out
  srcHistoryEntry = fetchurl {
    url = "https://raw.githubusercontent.com/GNOME/gnome-calculator/9bb6936ba74602ec891c1ffecdf1665dba1a1be4/data/history-entry.ui";
    sha256 = "0a6d6anwrg5l3kc7i8jyky4idnzi9bhjv9awi6615505pjhcxnaj";
  };

  srcHistoryView = fetchurl {
    url = "https://raw.githubusercontent.com/GNOME/gnome-calculator/b87b4f5cd0cff0b9cf9e9cd2a056c56be653cab1/data/history-view.ui";
    sha256 = "0zyq1mcxsh707jhh3vfqplk5s83lb26gvjz62l5l6rq5yrd43fyw";
  };

  prePatch = ''
    [ -f data/history-entry.ui ] && echo Remove the fix && exit 1
    [ -f data/history-view.ui ]  && echo Remove the fix && exit 1
    cp -v ${srcHistoryEntry} data/history-entry.ui
    cp -v ${srcHistoryView}  data/history-view.ui
  '';

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ bash gtk3 glib intltool itstool
                  libxml2 gnome3.gtksourceview mpfr gmp
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings_desktop_schemas gnome3.dconf libsoup ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
