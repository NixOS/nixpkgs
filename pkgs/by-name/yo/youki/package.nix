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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cybh83mbTG5V1vb5WDWh0uozJa3fha2ciTGMvHOaEQk=";
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-7kiQNiOJrn1wQorzSXLcwTZLAImPw2SFOdteG9hibZ0=";

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
