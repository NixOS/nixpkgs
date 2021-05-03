{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland-protocols
, pipewire, wayland, systemd, libdrm, iniparser, scdoc }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6ArUQfWx5rNdpsd8Q22MqlpxLT8GTSsymAf21zGe1KI=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols ];
  buildInputs = [ pipewire wayland systemd libdrm iniparser scdoc ];

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
