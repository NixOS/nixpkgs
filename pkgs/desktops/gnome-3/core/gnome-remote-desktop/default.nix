{ stdenv, fetchFromGitLab, meson, ninja, pkgconfig, python3, wrapGAppsHook
, glib, pipewire, systemd, libvncserver, libsecret, libnotify, gdk-pixbuf, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "0.1.7";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jadahl";
    repo = "gnome-remote-desktop";
    rev = version;
    sha256 = "0gmazc8ww0lyhx9iclhi982bkpjsnflrzv4qfm3q6hcy0il21fsc";
  };

  nativeBuildInputs = [ meson ninja pkgconfig python3 wrapGAppsHook ];

  buildInputs = [
    glib pipewire systemd libvncserver libsecret libnotify
    gdk-pixbuf # For libnotify
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  mesonFlags = [
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Mutter/RemoteDesktop;
    description = "GNOME Remote Desktop server";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
