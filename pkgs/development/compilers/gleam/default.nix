{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang,
  Security,
  nix-update-script,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Nr8OpinQ1Dmo6e8XpBYrtaRRhcX2s1TW/5nM1LxApGg=";
  };

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs =
    [
      openssl
      erlang
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-3McEZ/qwrLm8W2Umtah5shU74iFxLfe4ihp7x4YEvKc=";

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
