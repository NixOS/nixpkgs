{ stdenv, fetchurl, vala, intltool, pkgconfig, gtk3, glib
, json-glib, wrapGAppsHook, libpeas, bash, gobjectIntrospection
, gnome3, gtkspell3, shared-mime-info, libgee, libgit2-glib, librsvg, libsecret
, libsoup }:

stdenv.mkDerivation rec {
  name = "gitg-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gitg/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "26730d437d6a30d6e341b9e8da99d2134dce4b96022c195609f45062f82b54d5";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gitg"; };
  };

  preCheck = ''
    substituteInPlace tests/libgitg/test-commit.c --replace "/bin/bash" "${bash}/bin/bash"
  '';
  doCheck = true;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  propagatedUserEnvPkgs = [ shared-mime-info
                            gnome3.gnome-themes-standard ];

  buildInputs = [ gtk3 glib json-glib libgee libpeas gnome3.libsoup
                  libgit2-glib gtkspell3 gnome3.gtksourceview gnome3.gsettings-desktop-schemas
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
