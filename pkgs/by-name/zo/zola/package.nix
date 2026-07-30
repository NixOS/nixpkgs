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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zola";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mynoXNJE7IcP/0bMLUr/pJQbaEVEj2q/488Z4c9Tr5A=";
  };

  cargoHash = "sha256-AEgyaKenTMKAoJjzcklFFWjy5H5hkNZvVnlMZmqQxlM=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
  ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

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
    changelog = "https://github.com/getzola/zola/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dandellion
      dywedir
      _0x4A6F
    ];
  };
})
