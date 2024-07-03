{
  asciidoc,
  cairo,
  fdk_aac,
  fetchurl,
  freerdp3,
  fuse3,
  gdk-pixbuf,
  glib,
  gnome,
  lib,
  libdrm,
  libei,
  libepoxy,
  libnotify,
  libopus,
  libsecret,
  libxkbcommon,
  meson,
  ninja,
  nv-codec-headers-11,
  pipewire,
  pkg-config,
  polkit,
  python3,
  stdenv,
  systemd,
  tpm2-tss,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "46.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-l0Q+r/5LGmliaIakHSXL6ywUjT/tQ9khFcG30g1SOKs=";
  };

  nativeBuildInputs = [
    asciidoc
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    fdk_aac
    freerdp3
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libdrm
    libei
    libepoxy
    libnotify
    libopus
    libsecret
    libxkbcommon
    nv-codec-headers-11
    pipewire
    polkit # For polkit-gobject
    systemd
    tpm2-tss
  ];

  mesonFlags = [
    "-Dconf_dir=/etc/gnome-remote-desktop"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemd_sysusers_dir=${placeholder "out"}/lib/sysusers.d"
    "-Dsystemd_tmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    "-Dtests=false" # Too deep of a rabbit hole.
    # TODO: investigate who should be fixed here.
    "-Dc_args=-I${freerdp3}/include/winpr3"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop";
    description = "GNOME Remote Desktop server";
    mainProgram = "grdctl";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
