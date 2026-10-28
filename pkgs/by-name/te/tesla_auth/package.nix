{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_1,
  xdotool,
  gtk3,
  cairo,
  pango,
  gdk-pixbuf,
  glib,
  libsoup_3,
  openssl,
  glib-networking,
  nss,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tesla_auth";
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "adriankumpf";
    repo = "tesla_auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nidbHxvvvmL0PAh+nNLlYBYM5riGdt4pL4w4UxdEdV0=";
  };

  cargoHash = "sha256-TkqxzB6ufCFbibVCFM4dI2ZNQpGneNNR7j73YTgI+hE=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    xdotool
    gtk3
    cairo
    pango
    gdk-pixbuf
    glib
    libsoup_3
    openssl
    glib-networking
    nss
  ];

  env.STATIC_VCRUNTIME_NO_BUILD = "1";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Securely generate API tokens for third-party access to your Tesla";
    homepage = "https://github.com/adriankumpf/tesla_auth";
    license = lib.licenses.mit;
    mainProgram = "tesla_auth";
    maintainers = with lib.maintainers; [ brianmay ];
  };
})
