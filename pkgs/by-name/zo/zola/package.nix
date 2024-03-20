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
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    hash = "sha256-kNlFmCqWEfU2ktAMxXNKe6dmAV25voHjHYaovBYsOu8=";
  };

  cargoHash = "sha256-JWYuolHh/qdWF+i6WTgz/uDrkQ6V+SDFhEzGGkUA0E4=";

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
    description = "A fast static site generator with everything built-in";
    mainProgram = "zola";
    homepage = "https://www.getzola.org/";
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
  };
}
