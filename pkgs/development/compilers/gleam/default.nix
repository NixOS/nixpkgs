{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang,
  nodejs,
  bun,
  deno,
  Security,
  nix-update-script,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-0qK9dWkKnoXbIIBMN3p5noPEke/bgC8Bjtmf6lwtyr4=";
  };

  nativeBuildInputs = [
    git
    pkg-config
    erlang
    nodejs
    bun
    deno
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-EoRu8p6cUe1li54nVUkf+3qywIsDXh4ptIVLluJ3eFs=";

  checkFlags = [
    # Makes a network request
    "--skip=tests::echo::echo_dict"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
}
