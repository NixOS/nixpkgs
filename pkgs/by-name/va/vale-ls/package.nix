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

rustPlatform.buildRustPackage rec {
  pname = "vale-ls";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale-ls";
    tag = "v${version}";
    hash = "sha256-+2peLqj3/ny0hDwJVKEp2XS68VO50IvpCB2fvZoEdJo=";
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

  cargoHash = "sha256-KPgi0wZh1+PTKUmvCkLGPf+DZW5Tt4dQVK/cdxjm/1A=";

  postInstall = ''
    wrapProgram $out/bin/vale-ls \
      --suffix PATH : ${lib.makeBinPath [ vale ]}
  '';

  meta = with lib; {
    description = "LSP implementation for the Vale command-line tool";
    homepage = "https://github.com/errata-ai/vale-ls";
    license = licenses.mit;
    mainProgram = "vale-ls";
    maintainers = with maintainers; [
      foo-dogsquared
      jansol
    ];
  };
}
