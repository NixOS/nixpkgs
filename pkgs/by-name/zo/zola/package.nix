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
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    hash = "sha256-BjHAHj3EGE1L+EQdniS4OGOViOmcRDR5RhgmYK2zmVY=";
  };

  cargoHash = "sha256-ZbSdPi90Nl15YYN1tx9iNsdAjh6x02XKGG73IlOKdXo=";

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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
