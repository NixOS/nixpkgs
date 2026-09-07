{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  libdrm,
  wayland,
  wayland-protocols,
  wl-clipboard,
  libxkbcommon,
  libressl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waynergy";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "r-c-f";
    repo = "waynergy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cwpW6O+KJNDvSrHeSM1Ci7S0kNw6a8KCdGAIhowPEIw=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    libdrm
    wayland
    wayland-protocols
    wl-clipboard
    libxkbcommon
    libressl
  ];

  postPatch = ''
    substituteInPlace waynergy.desktop --replace "Exec=/usr/bin/waynergy" "Exec=$out/bin/waynergy"
  '';

  meta = {
    description = "Synergy client for Wayland compositors";
    longDescription = ''
      A synergy client for Wayland compositors
    '';
    homepage = "https://github.com/r-c-f/waynergy";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ maxhero ];
  };
})
