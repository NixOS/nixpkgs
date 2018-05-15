{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig
, wrapGAppsHook, itstool, desktop-file-utils
, glib, gtk3, evolution-data-server
, libuuid, webkitgtk, zeitgeist
, gnome3, libxml2 }:

let
  version = "3.28.2";
in stdenv.mkDerivation rec {
  name = "bijiben-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1z1dqspjpyym27yav7pr813x7k0jdxifgj5rdxgp4m6cs1ixcvjs";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 desktop-file-utils wrapGAppsHook
  ];

  buildInputs = [
    glib gtk3 libuuid webkitgtk gnome3.tracker
    gnome3.gnome-online-accounts zeitgeist
    gnome3.gsettings-desktop-schemas
    evolution-data-server
    gnome3.defaultIconTheme
  ];

  mesonFlags = [
    "-Dzeitgeist=true"
    "-Dupdate_mimedb=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "bijiben";
      attrPath = "gnome3.bijiben";
    };
  };

  meta = with stdenv.lib; {
    description = "Note editor designed to remain simple to use";
    homepage = https://wiki.gnome.org/Apps/Bijiben;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
