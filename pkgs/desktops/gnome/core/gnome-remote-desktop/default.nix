{ lib, stdenv
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
, libxkbcommon
, gdk-pixbuf
, freerdp
, fdk_aac
, tpm2-tss
, fuse3
, gnome
, libvncserver
, # Not recommended by upstream: https://github.com/GNOME/gnome-remote-desktop/commit/55ce55afa1ddb502d4c8e13ae813f348d5f76402
  enableVnc ? false
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "45.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-3NnBisIwZpVjH88AqIZFw443DroFxp3zn1QCBNTq/Y0=";
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
    freerdp
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
    libsecret
    libxkbcommon
    pipewire
    systemd
  ] ++ lib.optional enableVnc libvncserver;

  mesonFlags = [
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dtests=false" # Too deep of a rabbit hole.
  ] ++ lib.optional enableVnc "-Dvnc=true";

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
