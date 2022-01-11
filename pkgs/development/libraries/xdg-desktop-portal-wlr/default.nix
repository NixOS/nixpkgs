{ lib, stdenv, fetchFromGitHub, makeWrapper
, meson, ninja, pkg-config, wayland-protocols
, pipewire, wayland, systemd, libdrm, inih, scdoc, grim, slurp }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:13fbzh8bjnhk4xs8j9bpc01q3hy27zpbf0gkk1fnh3hm5pnyfyiv";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols makeWrapper ];
  buildInputs = [ pipewire wayland systemd libdrm inih scdoc ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-wlr --prefix PATH ":" ${lib.makeBinPath [ grim slurp ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
