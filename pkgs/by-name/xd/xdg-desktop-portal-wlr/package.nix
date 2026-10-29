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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-wlr";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "xdg-desktop-portal-wlr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4q3FdqNIh3f0rf+6JKl7NmFN8gMbPFL0U5jIwnvh1P0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = [ lib.maintainers.quantenzitrone ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
