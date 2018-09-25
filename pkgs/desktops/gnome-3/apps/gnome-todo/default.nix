{ stdenv, fetchurl, meson, ninja, pkgconfig, python3, wrapGAppsHook
, gettext, gnome3, glib, gtk, libpeas
, gnome-online-accounts, gsettings-desktop-schemas
, evolution-data-server, libxml2, libsoup, libical, rest, json-glib }:

let
  pname = "gnome-todo";
  version = "3.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "08ygqbib72jlf9y0a16k54zz51sncpq2wa18wp81v46q8301ymy7";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext python3 wrapGAppsHook
  ];
  buildInputs = [
    glib gtk libpeas gnome-online-accounts
    gsettings-desktop-schemas gnome3.defaultIconTheme
    # Plug-ins
    evolution-data-server libxml2 libsoup libical
    rest json-glib
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Personal task manager for GNOME";
    homepage = https://wiki.gnome.org/Apps/Todo;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
