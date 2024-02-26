{ stdenv
, lib
, fetchurl
, cairo
, meson
, ninja
, pkg-config
, python3
, asciidoc
, wrapGAppsHook
, glib
, libei
, libepoxy
, libdrm
, nv-codec-headers-11
, pipewire
, systemd
, libsecret
, libnotify
, libopus
, libxkbcommon
, gdk-pixbuf
, freerdp3
, fdk_aac
, tpm2-tss
, fuse3
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "46.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-sJwuGCjl9ciSBlbcwhwneeozWcdBlB59hh6VV4CLSRw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    asciidoc
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    freerdp3
    fdk_aac
    tpm2-tss
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libei
    libepoxy
    libdrm
    nv-codec-headers-11
    libnotify
    libopus
    libsecret
    libxkbcommon
    pipewire
    systemd
  ];

  mesonFlags = [
    "-Dconf_dir=/etc/gnome-remote-desktop"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemd_sysusers_dir=${placeholder "out"}/lib/sysusers.d"
    "-Dsystemd_tmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    "-Dtests=false" # Too deep of a rabbit hole.
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Mutter/RemoteDesktop";
    description = "GNOME Remote Desktop server";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
