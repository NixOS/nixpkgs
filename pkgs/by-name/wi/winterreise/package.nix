{
  lib,
  fetchFromGitHub,
  rustPlatform,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  gtk3,
  zlib,
  libxcb,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "winterreise";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "amkhlv";
    repo = "winterreise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fYrcA5sNNiyMroZJ5WQjhx0eyXVn1LUiyLocL6xnzhQ=";
  };

  buildInputs = [
    glib
    gdk-pixbuf
    cairo
    pango
    atk
    gtk3
    zlib
    libxcb
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-hu/5YYnD+gEI2fmm1x5FMMv1+INHA02+tkt1YxAhtJ8=";

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
