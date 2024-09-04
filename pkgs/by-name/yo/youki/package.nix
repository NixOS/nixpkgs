{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  dbus,
  libseccomp,
  systemd,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "youki";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dkVnNtBfvjf47p1N5/syHqjlDVnbKRDqNJ98ym5B+mg=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
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
  ];
  cargoTestFlags = [
    "-p"
    "youki"
  ];

  cargoHash = "sha256-Nv1LAkWYwWb0Izvd7UlKU4wx3vVkmO9Rcpt6AuTwObU=";

  meta = with lib; {
    description = "Container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    changelog = "https://github.com/containers/youki/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ builditluc ];
    platforms = platforms.linux;
    mainProgram = "youki";
  };
}
