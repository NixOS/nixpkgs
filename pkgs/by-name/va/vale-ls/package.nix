{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rustPlatform
, pkg-config
, openssl
, vale
}:

rustPlatform.buildRustPackage {
  pname = "vale-ls";
  version = "0.3.7-unstable-2024-03-13";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale-ls";
    rev = "473e16bc88ec48b35e2bd208adc174878c4d5396";
    hash = "sha256-ywJsnWMc9NSjYjsK6SXdMAQl+hcP+KQ7Xp1A99aeqAg=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ];

  checkFlags = [
    # The following tests are reaching to the network.
    "--skip=vale::tests"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # This test does not account for the existence of aarch64-linux machines,
    # despite upstream shipping artifacts for that architecture
    "--skip=utils::tests::arch"
  ];

  env.OPENSSL_NO_VENDOR = true;

  cargoHash = "sha256-JDsveGMQaDLFOba6oKYdm14IYDUf4+FIG4dPm09zWog=";

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
    platforms = platforms.unix;
  };
}

