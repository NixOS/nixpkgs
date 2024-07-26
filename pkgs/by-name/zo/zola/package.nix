{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, oniguruma
, darwin
, installShellFiles
, zola
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.19.1";

  src = builtins.fetchGit {
    url = "https://github.com/getzola/zola";
    ref = "refs/tags/v${version}";
    rev = "041da029eedbca30c195bc9cd8c1acf89b4f60c0";
  };

  cargoHash = "sha256-Q2Zx00Gf89TJcsOFqkq0b4e96clv/CLQE51gGONZZl0=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreServices SystemConfiguration
  ]);

  RUSTONIG_SYSTEM_LIBONIG = true;

  postInstall = ''
    installShellCompletion --cmd zola \
      --bash <($out/bin/zola completion bash) \
      --fish <($out/bin/zola completion fish) \
      --zsh <($out/bin/zola completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = zola; };

  meta = with lib; {
    description = "Fast static site generator with everything built-in";
    mainProgram = "zola";
    homepage = "https://www.getzola.org/";
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
  };
}
