{ stdenv
, fetchurl
, cairo
, meson
, ninja
, pkgconfig
, python3
, wrapGAppsHook
, glib
, pipewire
, systemd
, libvncserver
, libsecret
, libnotify
, gdk-pixbuf
, freerdp
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "0.1.9";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-8iZtp4tBRT7NNRKuzwop3rcMvq16RG/I2sAlEIsJ0M8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    freerdp
    gdk-pixbuf # For libnotify
    glib
    libnotify
    libsecret
    libvncserver
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

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Mutter/RemoteDesktop";
    description = "GNOME Remote Desktop server";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
