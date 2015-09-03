{ stdenv, intltool, fetchurl, python, pygobject3, atk
, pkgconfig, gtk3, glib, libsoup
, bash, makeWrapper, itstool, libxml2, python3Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify }:

stdenv.mkDerivation rec {
  name = "gnome-tweak-tool-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tweak-tool/${gnome3.version}/${name}.tar.xz";
    sha256 = "0r5x67aj79dsw2xl98q4harxv3hjs52g0m6pw43vx29lbir07r5i";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  makeFlags = [ "DESTDIR=/" ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  python pygobject3 libnotify gnome3.gnome_shell
                  libsoup gnome3.gnome_settings_daemon gnome3.nautilus
                  gnome3.gnome_desktop ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-tweak-tool" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --suffix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix PYTHONPATH : "$PYTHONPATH:$(toPythonPath $out)"
  '';

  patches = [
    ./find_gsettings.patch
    ./0001-Search-for-themes-and-icons-in-system-data-dirs.patch
    ./0002-Don-t-show-multiple-entries-for-a-single-theme.patch
    ./0003-Create-config-dir-if-it-doesn-t-exist.patch
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/GnomeTweakTool;
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
