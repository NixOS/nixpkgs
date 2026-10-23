{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pango,
  scdoc,
  pkg-config,
  installShellFiles,
  rustPlatform,
  wayland,
  jpegSupport ? true,
  pnmSupport ? true,
  qoiSupport ? true,
  webpSupport ? true,
  avifSupport ? true,
  jxlSupport ? true,
  clipboardSupport ? true,
  colorPickerSupport ? true,
  completionsSupport ? true,
  loggerSupport ? true,
  notificationsSupport ? true,
  selectorSupport ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayshot";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "wayshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MihZAAZ+K95jBE1gp0kne/+Z3rBUDqlphmyBI0FI1jE=";
  };
  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];
  buildInputs = [ wayland ] ++ lib.optional (selectorSupport || colorPickerSupport) pango;

  cargoHash = "sha256-SAI+KXRV4E130ROmNyXraaO31D341CRWXGuIPV8depA=";

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional jpegSupport "jpeg"
    ++ lib.optional pnmSupport "pnm"
    ++ lib.optional qoiSupport "qoi"
    ++ lib.optional webpSupport "webp"
    ++ lib.optional avifSupport "avif"
    ++ lib.optional jxlSupport "jxl"
    ++ lib.optional clipboardSupport "clipboard"
    ++ lib.optional colorPickerSupport "color_picker"
    ++ lib.optional completionsSupport "completions"
    ++ lib.optional loggerSupport "logger"
    ++ lib.optional notificationsSupport "notifications"
    ++ lib.optional selectorSupport "selector";

  postInstall = ''
    installManPage docs/wayshot.1.gz docs/wayshot.5.gz docs/wayshot.7.gz
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wayshot \
      --bash <($out/bin/wayshot --completions bash) \
      --fish <($out/bin/wayshot --completions fish) \
      --zsh <($out/bin/wayshot --completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screenshot crate for wlroots based compositors implementing the zwlr_screencopy_v1 protocol.";
    homepage = "https://crates.io/crates/wayshot";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      id3v1669
      Subserial
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshot";
  };
})
