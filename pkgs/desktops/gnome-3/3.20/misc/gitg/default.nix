{ stdenv, fetchurl, fetchgit, vala_0_32, intltool, libgit2, pkgconfig, gtk3, glib
, json_glib, webkitgtk, wrapGAppsHook, libpeas, bash, gobjectIntrospection
, gnome3, gtkspell3, shared_mime_info, libgee, libgit2-glib, librsvg, libsecret
, dconf}:


# TODO: icons and theme still does not work
# use packaged gnome3.adwaita-icon-theme 

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  preCheck = ''
    substituteInPlace tests/libgitg/test-commit.c --replace "/bin/bash" "${bash}/bin/bash"
  '';
  doCheck = true;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  propagatedUserEnvPkgs = [ shared_mime_info
                            gnome3.gnome_themes_standard ];

  buildInputs = [ vala_0_32 intltool libgit2 pkgconfig gtk3 glib json_glib webkitgtk libgee libpeas
                  libgit2-glib gtkspell3 gnome3.gsettings_desktop_schemas gnome3.gtksourceview
                  librsvg libsecret dconf
                  gobjectIntrospection gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ wrapGAppsHook ];

  # https://bugzilla.gnome.org/show_bug.cgi?id=758240
  preBuild = ''make -j$NIX_BUILD_CORES Gitg-1.0.gir'';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
