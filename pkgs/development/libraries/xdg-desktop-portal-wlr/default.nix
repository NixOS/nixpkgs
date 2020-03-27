{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, wayland-protocols
, pipewire, wayland, elogind, systemd, libdrm }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "2020-03-13";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "dfa0ac704064304824b6d4fea7870d33359dcd15";
    sha256 = "0k73nyd9z25ph4pc4vpa3xsd49b783qfk1dxqk20bgyg1ln54b81";
  };

  nativeBuildInputs = [ meson ninja pkgconfig wayland-protocols ];
  buildInputs = [ pipewire wayland elogind systemd libdrm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
