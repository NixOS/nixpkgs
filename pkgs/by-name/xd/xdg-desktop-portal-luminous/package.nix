{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  rustc,
  cargo,
  rustPlatform,
  makeWrapper,
  xdg-desktop-portal,
  slurp,
  cairo,
  pango,
  libxkbcommon,
  glib,
  pipewire,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-luminous";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "xdg-desktop-portal-luminous";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WxkCZwV4zuDvl0n4Qnanh/eSFTQu+8J1zMtBSTI2hM8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-HUImAQ2lDqrLYh+YDHjXNTHZiTthocB5U5L4gBmIGQQ=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustc
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    xdg-desktop-portal
    cairo
    pango
    glib
    pipewire
    libxkbcommon
  ];

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-luminous \
      --prefix PATH ":" ${lib.makeBinPath [ slurp ]} \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ wayland ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "xdg-desktop-portal backend for wlroots based compositors, providing screenshot and screencast";
    homepage = "https://github.com/waycrate/xdg-desktop-portal-luminous";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Rishik-Y ];
  };
})
