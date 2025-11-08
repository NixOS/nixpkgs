{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
  grim,
  inih,
  libdrm,
  libgbm,
  pipewire,
  scdoc,
  slurp,
  systemd,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "xdg-desktop-portal-wlr";
    rev = "v${version}";
    sha256 = "sha256-TAWrDH6kud4eXFJvfihImuEFm2uTOaqAOatG+7JmaEM=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
    makeWrapper
  ];
  buildInputs = [
    inih
    libdrm
    libgbm
    pipewire
    systemd
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-wlr --prefix PATH ":" ${
      lib.makeBinPath [
        bash
        grim
        slurp
      ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
