{ fetchurl, lib, stdenv, substituteAll, meson, ninja, pkg-config, gnome, glib, gtk3, gsettings-desktop-schemas
, gnome-desktop, dbus, json-glib, libICE, xmlto, docbook_xsl, docbook_xml_dtd_412, python3
, libxslt, gettext, makeWrapper, systemd, xorg, epoxy, gnugrep, bash, gnome-session-ctl }:

stdenv.mkDerivation rec {
  pname = "gnome-session";
  version = "40.1.1";

  outputs = ["out" "sessions"];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "10nzyhmgkrzk6i70kj7690na0hmsv6qy5bmr10akxq9jxqlphy4w";
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
    meson ninja pkg-config gettext makeWrapper
    xmlto libxslt docbook_xsl docbook_xml_dtd_412 python3
    dbus # for DTD
  ];

  buildInputs = [
    glib gtk3 libICE gnome-desktop json-glib xorg.xtrans gnome.adwaita-icon-theme
    gnome.gnome-settings-daemon gsettings-desktop-schemas systemd epoxy
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    # Use our provided `gnome-session-ctl`
    original="@libexecdir@/gnome-session-ctl"
    replacement="${gnome-session-ctl}/libexec/gnome-session-ctl"

    find data/ -type f -name "*.service.in" -exec sed -i \
      -e s,$original,$replacement,g \
      {} +
  '';

  # `bin/gnome-session` will reset the environment when run in wayland, we
  # therefor wrap `libexec/gnome-session-binary` instead which is the actual
  # binary needing wrapping
  preFixup = ''
    wrapProgram "$out/libexec/gnome-session-binary" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome.gnome-shell}/share"\
      --suffix XDG_CONFIG_DIRS : "${gnome.gnome-settings-daemon}/etc/xdg"
  '';

  # We move the GNOME sessions to another output since gnome-session is a dependency of
  # GDM itself. If we do not hide them, it will show broken GNOME sessions when GDM is
  # enabled without proper GNOME installation.
  postInstall = ''
    mkdir $sessions
    moveToOutput share/wayland-sessions "$sessions"
    moveToOutput share/xsessions "$sessions"

    # Our provided one is being used
    rm -rf $out/libexec/gnome-session-ctl
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-session";
      attrPath = "gnome.gnome-session";
    };
    providedSessions = [ "gnome" "gnome-xorg" ];
  };

  meta = with lib; {
    description = "GNOME session manager";
    homepage = "https://wiki.gnome.org/Projects/SessionManagement";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
