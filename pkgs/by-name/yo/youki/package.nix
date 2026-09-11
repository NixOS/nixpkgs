{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  getconf,
  dbus,
  libseccomp,
  systemd,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "youki";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "youki-dev";
    repo = "youki";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EiBQDMiqqDrJ+FpMbdNZW1DtKxTpVMSfibQlHXs+iLM=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    getconf
  ];

  buildInputs = [
    dbus
    libseccomp
    systemd
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd youki \
      --bash <($out/bin/youki completion -s bash) \
      --fish <($out/bin/youki completion -s fish) \
      --zsh <($out/bin/youki completion -s zsh)
  '';

  cargoBuildFlags = [
    "-p"
    "youki"
    "--features"
    "systemd"
  ];

  cargoTestFlags = [
    "-p"
    "youki"
  ];

  cargoHash = "sha256-v4yyEhJ5Gm0Z9Zs8CQiU+EKgRujeCqKfxt2C4OPdF5M=";

  meta = {
    description = "Container runtime written in Rust";
    homepage = "https://youki-dev.github.io/youki/";
    changelog = "https://github.com/youki-dev/youki/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ builditluc ];
    platforms = lib.platforms.linux;
    mainProgram = "youki";
  };
})
