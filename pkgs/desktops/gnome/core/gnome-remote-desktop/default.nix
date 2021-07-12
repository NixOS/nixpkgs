{ lib, stdenv
, fetchurl
, cairo
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, glib
, pipewire
, systemd
, libvncserver
, libsecret
, libnotify
, libxkbcommon
, gdk-pixbuf
, freerdp
, fuse3
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-mvpuUlVwo3IJP5cwM4JwkDiU87H5+KnfX1eDbqHSnek=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    freerdp
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libnotify
    libsecret
    libvncserver
    libxkbcommon
    pipewire
    systemd
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  mesonFlags = [
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
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
