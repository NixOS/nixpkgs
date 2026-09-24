{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  pkg-config,
  openssl,
  vale,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vale-ls";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vale-cli";
    repo = "vale-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KgPSFyjKdXfjdZfoxHrhEUj1Km8oh1gd9eGSHKlsliM=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # The following tests are reaching to the network.
    "--skip=vale::tests"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # This test does not account for the existence of aarch64-linux machines,
    # despite upstream shipping artifacts for that architecture
    "--skip=utils::tests::arch"
  ];

  env.OPENSSL_NO_VENDOR = true;

  cargoHash = "sha256-7hiNI7tzfA95SWJfbRpf9FuyU/9bQlp5Uix6c36ycyE=";

  postInstall = ''
    wrapProgram $out/bin/vale-ls \
      --suffix PATH : ${lib.makeBinPath [ vale ]}
  '';

  meta = {
    description = "LSP implementation for the Vale command-line tool";
    homepage = "https://github.com/vale-cli/vale-ls";
    license = lib.licenses.mit;
    mainProgram = "vale-ls";
    maintainers = with lib.maintainers; [
      jansol
    ];
  };
})
