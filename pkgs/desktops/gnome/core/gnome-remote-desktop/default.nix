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
, mesa
, libgudev
, xvfb-run
, dbus
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "43.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-vYR8PKdzYJlTNEYs1GnkWhJHnxHAxI6WUCjtXLgHpbI=";
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
    libepoxy
    libdrm
    nv-codec-headers-11
    libnotify
    libsecret
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
    patchShebangs \
      tests/vnc-test-runner.sh \
      tests/run-vnc-tests.py

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
