{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "vale-ls";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xsYokuRAdZZ3lz9/J02QDPMR3p0pxxqD1ljRdQI5GKE=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [ openssl ];

  # The following tests are reaching to the network.
  checkFlags = [
    "--skip=vale::tests"
  ];

  cargoHash = "sha256-QEU9e8KTAnLD9ykV+C87iVKojX2aEDRwocwvZcxpOU8=";
  cargoPatches = [ ./0001-Update-dependencies.patch ];

  meta = with lib; {
    description = "LSP implementation for the Vale command-line tool";
    homepage = "https://github.com/errata-ai/vale-ls";
    license = licenses.mit;
    mainProgram = "vale-ls";
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.unix;
  };
}
