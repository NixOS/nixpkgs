{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rustPlatform
, pkg-config
, openssl
, darwin
, vale
}:

rustPlatform.buildRustPackage rec {
  pname = "vale-ls";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale-ls";
    rev = "refs/tags/v${version}";
    hash = "sha256-+2peLqj3/ny0hDwJVKEp2XS68VO50IvpCB2fvZoEdJo=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    SystemConfiguration
  ]);

  checkFlags = [
    # The following tests are reaching to the network.
    "--skip=vale::tests"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # This test does not account for the existence of aarch64-linux machines,
    # despite upstream shipping artifacts for that architecture
    "--skip=utils::tests::arch"
  ];

  env.OPENSSL_NO_VENDOR = true;

  cargoHash = "sha256-YurMB54jeMQIAOgDQhXEYrkYUYrSl02M9JG5Wtp6Eb8=";

  postInstall = ''
    wrapProgram $out/bin/vale-ls \
      --prefix PATH : ${lib.makeBinPath [ vale ]}
  '';

  meta = with lib; {
    description = "LSP implementation for the Vale command-line tool";
    homepage = "https://github.com/errata-ai/vale-ls";
    license = licenses.mit;
    mainProgram = "vale-ls";
    maintainers = with maintainers; [ foo-dogsquared jansol ];
  };
}

