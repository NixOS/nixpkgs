{
  lib,
  darwin,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "twm";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = "twm";
    tag = "v${version}";
    hash = "sha256-SiwLqUq/gC8Tr31jjblLc9YP4yBi9HL38W83kgh7eJI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iqFPerePQStx1QsFW+2nDNSZEMlDW2HNW05i38rMYgg=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd twm \
      --bash <($out/bin/twm --print-bash-completion) \
      --zsh <($out/bin/twm --print-zsh-completion) \
      --fish <($out/bin/twm --print-fish-completion)

    $out/bin/twm --print-man > twm.1
    installManPage twm.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "twm";
  };
}
