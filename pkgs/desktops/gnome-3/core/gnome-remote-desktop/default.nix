{ stdenv, fetchFromGitLab, meson, ninja, pkgconfig, python3, wrapGAppsHook
, glib, pipewire, systemd, libvncserver, libsecret, libnotify, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "0.1.8";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jadahl";
    repo = "gnome-remote-desktop";
    rev = version;
    sha256 = "1wcvk0w4p0wnqnrjkbwvqcby9dd4nj0cm9cz0fqna31qfjrvb913";
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
    homepage = "https://wiki.gnome.org/Projects/Mutter/RemoteDesktop";
    description = "GNOME Remote Desktop server";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
