{ stdenv, fetchFromGitLab, meson, ninja, pkgconfig, python3, wrapGAppsHook
, glib, pipewire, systemd, libvncserver, libsecret, libnotify, gdk_pixbuf, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-remote-desktop-${version}";
  version = "0.1.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jadahl";
    repo = "gnome-remote-desktop";
    rev = version;
    sha256 = "1d49kxhi1bn8ssh6nybg7d6zajqwc653czbsms2d59dbhj8mn75f";
  };

  nativeBuildInputs = [ meson ninja pkgconfig python3 wrapGAppsHook ];

  buildInputs = [
    glib pipewire systemd libvncserver libsecret libnotify
    gdk_pixbuf # For libnotify
  ];

  postPatch = ''
    substituteInPlace meson.build --replace pipewire-0.1 pipewire-0.2

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
