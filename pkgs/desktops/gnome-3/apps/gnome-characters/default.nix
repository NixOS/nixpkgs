{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gnome3, glib, gtk3, pango, wrapGAppsHook, python3
, gobject-introspection, gjs, libunistring, gsettings-desktop-schemas, adwaita-icon-theme, gnome-desktop }:

stdenv.mkDerivation rec {
  name = "gnome-characters-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1cwazk9x9fs4lf89jqxdian15dk8zfsnpypgl1kknnw8r9mv0bzd";
  };

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-characters";
      attrPath = "gnome3.gnome-characters";
    };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook python3 gobject-introspection ];
  buildInputs = [
    glib gtk3 gjs pango gsettings-desktop-schemas
    adwaita-icon-theme libunistring
    # typelib
    gnome-desktop
  ];

  mesonFlags = [
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/services"
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Design/Apps/CharacterMap;
    description = "Simple utility application to find and insert unusual characters";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
