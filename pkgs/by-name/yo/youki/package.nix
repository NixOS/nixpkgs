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

rustPlatform.buildRustPackage rec {
  pname = "youki";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "youki";
    rev = "v${version}";
    hash = "sha256-r8/H/qTPBoNubg3f4+WC8lBkQXpdEE8Dapt2sGoFcTc=";
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

  cargoHash = "sha256-S2Cv7k4ine9/VbY2r8BSRwqVBtuqX55RYglm9W+LXvc=";

  meta = {
    description = "Container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    changelog = "https://github.com/containers/youki/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ builditluc ];
    platforms = lib.platforms.linux;
    mainProgram = "youki";
  };
}
