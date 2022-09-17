{ lib, stdenv
, fetchurl
, cairo
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, glib
, libepoxy
, libdrm
, nv-codec-headers-11
, pipewire
, systemd
, libvncserver
, libsecret
, libnotify
, libxkbcommon
, gdk-pixbuf
, freerdp
, fuse3
, mesa
, libgudev
, xvfb-run
, dbus
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "42.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-TU0jPvov+lRnMGo8w86Le6IyUtQtSxJy1crJ1d5Fy5o=";
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
    libepoxy
    libdrm
    nv-codec-headers-11
    libnotify
    libsecret
    libvncserver
    libxkbcommon
    pipewire
    systemd
  ] ++ checkInputs;

  checkInputs = [
    mesa # for gbm
    libgudev
    xvfb-run
    python3.pkgs.dbus-python
    python3.pkgs.pygobject3
    dbus # for dbus-run-session
  ];

  mesonFlags = [
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
  ];

  # Too deep of a rabbit hole.
  doCheck = false;

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs \
      tests/vnc-test-runner.sh \
      tests/run-vnc-tests.py \
      meson_post_install.py

    substituteInPlace tests/vnc-test-runner.sh \
      --replace "dbus-run-session" "dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf"
  '';

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
