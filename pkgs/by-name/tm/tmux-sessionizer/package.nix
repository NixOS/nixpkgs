{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  testers,
  tmux-sessionizer,
  installShellFiles,
}:
let

  name = "tmux-sessionizer";
  version = "0.4.5";

in
rustPlatform.buildRustPackage {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = "v${version}";
    hash = "sha256-uoSm9oWZSiqwsg7dVVMay9COL5MEK3a5Pd+D66RzzPM=";
  };

  cargoHash = "sha256-fd0IEORqnqxKN9zisXTT0G8CwRNVsGd3HZmCVY5DKsM=";

  passthru.tests.version = testers.testVersion {
    package = tmux-sessionizer;
    version = version;
  };

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tms \
      --bash <(COMPLETE=bash $out/bin/tms) \
      --fish <(COMPLETE=fish $out/bin/tms) \
      --zsh <(COMPLETE=zsh $out/bin/tms)
  '';

  meta = with lib; {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [
      vinnymeller
      mrcjkb
    ];
    mainProgram = "tms";
  };
}
