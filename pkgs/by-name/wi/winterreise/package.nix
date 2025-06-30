{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkgs,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  gtk3,
  zlib,
  xcbutil,
  libXmu,
  xcbutilwm,
  libxcb,
  pkg-config,
  python314,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "winterreise";
  version = "2.0";
  src = fetchFromGitHub {
    owner = "amkhlv";
    repo = "winterreise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YRwzpQZvG/pE41ZI0yhqRQUSkg+i9EiuAciVSF8V8k4=";
  };
  buildInputs = [
    glib
    gdk-pixbuf
    cairo
    pango
    atk
    gtk3
    zlib
    xcbutil
    libXmu
    xcbutilwm
    libxcb
  ];
  nativeBuildInputs = [
    pkg-config
  ];
  useFetchCargoVendor = true;
  cargoHash = "sha256-y63hRmyOQzs8YB1UCX88DkDtsRHi7JIaOQPWqOrSmsY=";
  meta = {
    description = "Keyboard navigation and window tiling for X11 Linux desktop";
    homepage = "https://github.com/amkhlv/winterreise";
    maintainers = with lib.maintainers; [
      amkhlv
    ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl3Only
    ];
  };
})
