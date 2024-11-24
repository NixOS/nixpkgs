{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, git
, pkg-config
, openssl
, erlang
, Security
, nix-update-script
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SiP9h0m2Y+eRicRWTmwjqXpmgizoUadofgSMmRYEFg0=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl erlang ] ++
    lib.optionals stdenv.hostPlatform.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-MQX0hQlucaOgX42XHw55QCsIADAib7cKs4PeMc7Za4s=";

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
