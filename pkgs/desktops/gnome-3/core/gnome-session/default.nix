{ fetchurl, stdenv, substituteAll, meson, ninja, pkgconfig, gnome3, glib, gtk3, gsettings-desktop-schemas
, gnome-desktop, dbus, json-glib, libICE, xmlto, docbook_xsl, docbook_xml_dtd_412, python3
, libxslt, gettext, makeWrapper, systemd, xorg, epoxy, gnugrep, bash }:

stdenv.mkDerivation rec {
  pname = "gnome-session";
  version = "3.38.0";

  outputs = ["out" "sessions"];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rrxjk3vbqy3cdgnl7rw71dvcyrvhwq3m6s53dnkyjxsrnr0xk3v";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gsettings = "${glib.bin}/bin/gsettings";
      dbusLaunch = "${dbus.lib}/bin/dbus-launch";
      grep = "${gnugrep}/bin/grep";
      bash = "${bash}/bin/bash";
    })
  ];

  mesonFlags = [ "-Dsystemd=true" "-Dsystemd_session=default" ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext makeWrapper
    xmlto libxslt docbook_xsl docbook_xml_dtd_412 python3
    dbus # for DTD
  ];

  buildInputs = [
    glib gtk3 libICE gnome-desktop json-glib xorg.xtrans gnome3.adwaita-icon-theme
    gnome3.gnome-settings-daemon gsettings-desktop-schemas systemd epoxy
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  # `bin/gnome-session` will reset the environment when run in wayland, we
  # therefor wrap `libexec/gnome-session-binary` instead which is the actual
  # binary needing wrapping
  preFixup = ''
    wrapProgram "$out/libexec/gnome-session-binary" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome3.gnome-shell}/share"\
      --suffix XDG_CONFIG_DIRS : "${gnome3.gnome-settings-daemon}/etc/xdg"
  '';

  # We move the GNOME sessions to another output since gnome-session is a dependency of
  # GDM itself. If we do not hide them, it will show broken GNOME sessions when GDM is
  # enabled without proper GNOME installation.
  postInstall = ''
    mkdir $sessions
    moveToOutput share/wayland-sessions "$sessions"
    moveToOutput share/xsessions "$sessions"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-session";
      attrPath = "gnome3.gnome-session";
    };
    providedSessions = [ "gnome" "gnome-xorg" ];
  };

  meta = with stdenv.lib; {
    description = "GNOME session manager";
    homepage = "https://wiki.gnome.org/Projects/SessionManagement";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
