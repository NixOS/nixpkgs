{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = "lunatic";
    rev = "v${version}";
    hash = "sha256-uMMssZaPDZn3bOtQIho+GvUCPmzRllv7eJ+SJuKaYtg=";
  };

  cargoPatches = [
    # the `time` dependency was out of date and that broke the build
    ./0001-update-dependencies-cargo-lock.patch
  ];

  cargoHash = "sha256-yGeCpzpeoVjTioGEL3yBJ4tDveJnoy+6UMfog84yahY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  checkFlags = [
    # requires simd support which is not always available on hydra
    "--skip=state::tests::import_filter_signature_matches"
  ];

  meta = with lib; {
    description = "Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
