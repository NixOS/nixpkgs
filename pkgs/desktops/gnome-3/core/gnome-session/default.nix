{ fetchurl, stdenv, meson, ninja, pkgconfig, gnome3, glib, gtk, gsettings-desktop-schemas
, gnome-desktop, dbus, json-glib, libICE, xmlto, docbook_xsl, docbook_xml_dtd_412
, libxslt, gettext, makeWrapper, systemd, xorg, epoxy }:

stdenv.mkDerivation rec {
  name = "gnome-session-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1ldcalj9i7qharvw8k8gf7pkcvwb1qwiag2ckffx9x8ic2d3v00b";
  };

  mesonFlags = [ "-Dsystemd=true" ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext makeWrapper
    xmlto libxslt docbook_xsl docbook_xml_dtd_412
    dbus # for DTD
  ];

  buildInputs = [
    glib gtk libICE gnome-desktop json-glib xorg.xtrans gnome3.defaultIconTheme
    gnome3.gnome-settings-daemon gsettings-desktop-schemas systemd epoxy
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  # FIXME: glib binaries shouldn't be in .dev!
  preFixup = ''
    for desktopFile in $(grep -rl "Exec=gnome-session" $out/share)
    do
      echo "Patching gnome-session path in: $desktopFile"
      sed -i "s,^Exec=gnome-session,Exec=$out/bin/gnome-session," $desktopFile
    done
    wrapProgram "$out/bin/gnome-session" \
      --prefix PATH : "${glib.dev}/bin" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome3.gnome-shell}/share"\
      --suffix XDG_CONFIG_DIRS : "${gnome3.gnome-settings-daemon}/etc/xdg"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-session";
      attrPath = "gnome3.gnome-session";
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME session manager";
    homepage = https://wiki.gnome.org/Projects/SessionManagement;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
