{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  oniguruma,
  installShellFiles,
  zola,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    hash = "sha256-+/0MhKKDSbOEa5btAZyaS3bQPeGJuski/07I4Q9v9cg=";
  };

  cargoHash = "sha256-K2wdq61FVVG9wJF+UcRZyZ2YSEw3iavboAGkzCcTGkU=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zola \
      --bash <($out/bin/zola completion bash) \
      --fish <($out/bin/zola completion fish) \
      --zsh <($out/bin/zola completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = zola; };

  meta = {
    description = "Fast static site generator with everything built-in";
    mainProgram = "zola";
    homepage = "https://www.getzola.org/";
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dandellion
      dywedir
      _0x4A6F
    ];
  };
}
