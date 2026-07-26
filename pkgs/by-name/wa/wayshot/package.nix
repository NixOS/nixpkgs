{
  lib,
  libgbm,
  libjxl,
  libGL,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pango,
  pkg-config,
  installShellFiles,
  rustPlatform,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayshot";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "wayshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sbY3h3FoWxDmxSng9YvYpt3kyasVJGsykYC/7tblFn8=";
  };
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    pango
    libgbm
    libjxl
    libGL
    wayland
  ];
  cargoHash = "sha256-J7ZKWx258bBCNBd061aCeKgTdcWMUF4yzAiIa9l8ZRA=";

  postInstall = ''
    installManPage docs/wayshot.1.scd docs/wayshot.5.scd docs/wayshot.7.scd
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wayshot \
      --bash <($out/bin/wayshot --completions bash) \
      --fish <($out/bin/wayshot --completions fish) \
      --zsh <($out/bin/wayshot --completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      id3v1669
      Subserial
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshot";
  };
})
