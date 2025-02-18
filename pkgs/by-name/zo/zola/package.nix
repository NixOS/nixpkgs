{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  oniguruma,
  darwin,
  installShellFiles,
  zola,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    hash = "sha256-pk7xlNgYybKHm7Zn6cbO1CMUOAKVtX1uxq+6vl48FZk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3Po9PA5XJeiwkMaq/8glfaC1E7QmSeuR81BwOyMznOM=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      oniguruma
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
        SystemConfiguration
      ]
    );

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
    maintainers = with maintainers; [
      dandellion
      dywedir
      _0x4A6F
    ];
  };
}
