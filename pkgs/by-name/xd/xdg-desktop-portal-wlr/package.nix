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
  systemdLibs,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-wlr";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "xdg-desktop-portal-wlr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HITf/hgiASWvn/z49mzS8IS1vuyXwdk1JiAOOHRSQMo=";
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
    systemdLibs
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

  meta = {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with lib.maintainers; [ minijackson ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
