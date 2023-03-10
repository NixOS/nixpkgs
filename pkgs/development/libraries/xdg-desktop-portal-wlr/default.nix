{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, meson
, ninja
, pkg-config
, wayland-protocols
, wayland-scanner
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

  # scdoc: mark as build-time dependency
  # https://github.com/emersion/xdg-desktop-portal-wlr/pull/248
  patches = [(fetchpatch {
    url = "https://github.com/emersion/xdg-desktop-portal-wlr/commit/92ccd62428082ba855e359e83730c4370cd1aac7.patch";
    hash = "sha256-mU1whfp7BoSylaS3y+YwfABImZFOeuItSXCon0C7u20=";
  })];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner makeWrapper ];
  buildInputs = [ inih libdrm mesa pipewire systemd wayland wayland-protocols ];

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
