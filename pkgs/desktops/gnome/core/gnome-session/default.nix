{
  fetchurl,
  lib,
  stdenv,
  substituteAll,
  meson,
  ninja,
  pkg-config,
  gnome,
  adwaita-icon-theme,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  gnome-desktop,
  dbus,
  json-glib,
  libICE,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_412,
  python3,
  libxslt,
  gettext,
  makeWrapper,
  systemd,
  xorg,
  libepoxy,
  bash,
  gnome-session-ctl,
}:

stdenv.mkDerivation rec {
  pname = "gnome-session";
  # Also bump ./ctl.nix when bumping major version.
  version = "46.0";

  outputs = [
    "out"
    "sessions"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-xuFiSvYJC8ThoZH+Imir+nqN4HgxynpX8hfmeb97mlQ=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gsettings = "${glib.bin}/bin/gsettings";
      dbusLaunch = "${dbus.lib}/bin/dbus-launch";
      bash = "${bash}/bin/bash";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    makeWrapper
    xmlto
    libxslt
    docbook_xsl
    docbook_xml_dtd_412
    python3
    dbus # for DTD
  ];

  buildInputs = [
    glib
    gtk3
    libICE
    gnome-desktop
    json-glib
    xorg.xtrans
    adwaita-icon-theme
    gnome.gnome-settings-daemon
    gsettings-desktop-schemas
    systemd
    libepoxy
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

  # `bin/gnome-session` will reset the environment when run in wayland, we
  # therefor wrap `libexec/gnome-session-binary` instead which is the actual
  # binary needing wrapping
  preFixup = ''
    wrapProgram "$out/libexec/gnome-session-binary" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome.gnome-shell}/share" \
      --suffix XDG_CONFIG_DIRS : "${gnome.gnome-settings-daemon}/etc/xdg"
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-session";
      attrPath = "gnome.gnome-session";
    };
    providedSessions = [
      "gnome"
      "gnome-xorg"
    ];
  };

  meta = with lib; {
    description = "GNOME session manager";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-session";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
