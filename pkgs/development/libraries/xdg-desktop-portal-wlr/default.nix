{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, meson
, ninja
, pkg-config
, wayland-protocols
, grim
, inih
, libdrm
, mesa
, pipewire
, scdoc
, slurp
, systemd
, wayland
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UztkfvMIbslPd/d262NZFb6WfESc9nBsSSH96BA4Aqw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols makeWrapper ];
  buildInputs = [ inih libdrm mesa pipewire scdoc systemd wayland ];

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
