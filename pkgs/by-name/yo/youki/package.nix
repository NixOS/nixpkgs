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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UKdl6+NHDriQYDgZzdWnH07xneLB/40tpCKhaRhzriA=";
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
  cargoHash = "sha256-JI37KtuWLhFiusQTqKy2DpSdgTY4jNuzsEkoyhLPieI=";

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
