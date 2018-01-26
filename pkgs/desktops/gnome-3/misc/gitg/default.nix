{ stdenv, fetchurl, vala, intltool, pkgconfig, gtk3, glib
, json_glib, wrapGAppsHook, libpeas, bash, gobjectIntrospection
, gnome3, gtkspell3, shared_mime_info, libgee, libgit2-glib, librsvg, libsecret
, libsoup }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  preCheck = ''
    substituteInPlace tests/libgitg/test-commit.c --replace "/bin/bash" "${bash}/bin/bash"
  '';
  doCheck = true;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  propagatedUserEnvPkgs = [ shared_mime_info
                            gnome3.gnome_themes_standard ];

  buildInputs = [ gtk3 glib json_glib libgee libpeas gnome3.libsoup
                  libgit2-glib gtkspell3 gnome3.gtksourceview gnome3.gsettings_desktop_schemas
                  librsvg libsecret gobjectIntrospection gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ vala wrapGAppsHook intltool pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
