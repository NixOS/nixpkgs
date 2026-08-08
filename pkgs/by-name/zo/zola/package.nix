{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  pkg-config,
  oniguruma,
  installShellFiles,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zola";
  version = "0.23.4";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9lSl4/vM+mO2YQA1uq6knVZ6uENhxPPjJ9a8z2A5aRc=";
  };

  cargoHash = "sha256-LsnnX8zyyJexmc+aGiI3Lwbrb/rjtKiL15CSM/cEFOY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
  ];

  checkInputs = [
    cacert
  ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zola \
      --bash <($out/bin/zola completion bash) \
      --fish <($out/bin/zola completion fish) \
      --zsh <($out/bin/zola completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

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
