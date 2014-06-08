{ stdenv, intltool, fetchurl, python, pygobject3, atk
, pkgconfig, gtk3, glib, hicolor_icon_theme, libsoup
, bash, makeWrapper, itstool, libxml2, python3Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify }:

stdenv.mkDerivation rec {
  name = "gnome-tweak-tool-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tweak-tool/3.10/${name}.tar.xz";
    sha256 = "fb5af9022c0521a925ef9f295e4080212b1b45427cd5f5f3a901667590afa7ec";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  makeFlags = [ "DESTDIR=/" ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  python pygobject3 libnotify gnome3.gnome_shell
                  libsoup gnome3.gnome_settings_daemon gnome3.nautilus
                  gnome3.gnome_desktop ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-tweak-tool" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${libsoup}/lib:${gnome3.gnome_desktop}/lib:${libnotify}/lib:${gtk3}/lib:${atk}/lib" \
      --prefix PYTHONPATH : "$PYTHONPATH:$(toPythonPath $out)"
  '';

  patches = [ ./find_gsettings.patch ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/GnomeTweakTool;
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
