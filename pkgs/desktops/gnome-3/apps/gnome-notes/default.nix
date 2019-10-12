{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig
, wrapGAppsHook, itstool, desktop-file-utils, python3
, glib, gtk3, evolution-data-server, gnome-online-accounts
, libuuid, webkitgtk, zeitgeist
, gnome3, libxml2, gsettings-desktop-schemas, tracker }:

let
  version = "3.34.0";
in stdenv.mkDerivation {
  pname = "gnome-notes";
  inherit version;

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${stdenv.lib.versions.majorMinor version}/bijiben-${version}.tar.xz";
    sha256 = "0wrnsspcg4s0vdfc23cc84xy02k3b19yim9s4k0vv23b69n37n1l";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 desktop-file-utils python3 wrapGAppsHook
  ];

  buildInputs = [
    glib gtk3 libuuid webkitgtk tracker
    gnome-online-accounts zeitgeist
    gsettings-desktop-schemas
    evolution-data-server
    gnome3.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Dzeitgeist=true"
    "-Dupdate_mimedb=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "bijiben";
      attrPath = "gnome3.gnome-notes";
    };
  };

  meta = with stdenv.lib; {
    description = "Note editor designed to remain simple to use";
    homepage = https://wiki.gnome.org/Apps/Notes;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
