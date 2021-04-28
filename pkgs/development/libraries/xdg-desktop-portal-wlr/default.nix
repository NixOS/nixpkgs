{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland-protocols
, pipewire, wayland, systemd, libdrm }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vjz0y3ib1xw25z8hl679l2p6g4zcg7b8fcd502bhmnqgwgdcsfx";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols ];
  buildInputs = [ pipewire wayland systemd libdrm ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  meta = with lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
