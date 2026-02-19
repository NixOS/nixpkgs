{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  dbus,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tokstat";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "tokstat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J144les0gxAFt34+r2hcikIyLKm+A1p8zNg+FljZ41o=";
  };

  cargoHash = "sha256-llS2UrJ9B+JSNkBUYioEEbe36lGgIr3ifjBXgPhTRnE=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
  ];

  # For keyring support
  PKG_CONFIG_PATH = lib.optionalString stdenv.hostPlatform.isLinux "${dbus.dev}/lib/pkgconfig";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Generate shell completions
    installShellCompletion --cmd tokstat \
      --bash <($out/bin/tokstat --generate bash 2>/dev/null) \
      --fish <($out/bin/tokstat --generate fish 2>/dev/null) \
      --zsh <($out/bin/tokstat --generate zsh 2>/dev/null)
  '';

  meta = {
    description = "CLI application to monitor token quotas across multiple AI providers";
    homepage = "https://github.com/pbek/tokstat";
    changelog = "https://github.com/pbek/tokstat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "tokstat";
  };
})
