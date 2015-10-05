{ stdenv, fetchurl, fetchgit, vala, intltool, libgit2, pkgconfig, gtk3, glib
, json_glib, webkitgtk,  makeWrapper, libpeas, bash, gobjectIntrospection
, gnome3, gtkspell3, shared_mime_info, libgee, libgit2-glib, librsvg }:

# TODO: icons and theme still does not work
# use packaged gnome3.adwaita-icon-theme 

let
  majorVersion = "3.14";
in
stdenv.mkDerivation rec {
  name = "gitg-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gitg/${majorVersion}/${name}.tar.xz";
    sha256 = "8e45a7198896eedd829a20ff8de437a08869d30005638114ca87abd42ffea11b";
  };

  preCheck = ''
    substituteInPlace tests/libgitg/test-commit.c --replace "/bin/bash" "${bash}/bin/bash"
  '';
  doCheck = true;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  propagatedUserEnvPkgs = [ shared_mime_info
                            gnome3.gnome_themes_standard ];

  buildInputs = [ vala intltool libgit2 pkgconfig gtk3 glib json_glib webkitgtk libgee libpeas
                  libgit2-glib gtkspell3 gnome3.gsettings_desktop_schemas gnome3.gtksourceview librsvg
                  gobjectIntrospection makeWrapper gnome3.adwaita-icon-theme ];

  preFixup = ''
    wrapProgram "$out/bin/gitg" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
