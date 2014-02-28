{ stdenv, fetchurl, fetchgit, vala, intltool, libgit2, pkgconfig, gtk3, glib
, json_glib, webkitgtk,  makeWrapper, libpeas, bash, gobjectIntrospection
, gnome3, gtkspell3, shared_mime_info, libgee, libgit2-glib, librsvg }:

# TODO: icons and theme still does not work
# use packaged gnome3.gnome_icon_theme_symbolic 

stdenv.mkDerivation rec {
  name = "gitg-0.3.2";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gitg/0.3/${name}.tar.xz";
    sha256 = "03vc59d1r3326piqdph6qjqnc40chm1lpg52lpf8466ddjs0x8vp";
  };

  configureFlags = [ "--disable-static" ];

  preCheck = ''
    substituteInPlace tests/libgitg/test-commit.c --replace "/bin/bash" "${bash}/bin/bash"
  '';
  doCheck = true;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  propagatedUserEnvPkgs = [ shared_mime_info
                            gnome3.gnome_themes_standard ];

  buildInputs = [ vala intltool libgit2 pkgconfig gtk3 glib json_glib webkitgtk libgee libpeas
                  libgit2-glib gtkspell3 gnome3.gsettings_desktop_schemas gnome3.gtksourceview librsvg
                  gobjectIntrospection makeWrapper gnome3.gnome_icon_theme_symbolic gnome3.gnome_icon_theme ];

  postInstall = ''
    wrapProgram "$out/bin/gitg" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share"
  '';

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
    rm $out/share/gitg/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
