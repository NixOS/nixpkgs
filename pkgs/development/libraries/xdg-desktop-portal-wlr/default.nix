{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland-protocols
, pipewire, wayland, elogind, systemd, libdrm }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "12k92h9dmn1fyn8nzxk69cyv0gnb7g9gj7a66mw5dcl5zqnl07nc";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols ];
  buildInputs = [ pipewire wayland elogind systemd libdrm ];

  meta = with lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
