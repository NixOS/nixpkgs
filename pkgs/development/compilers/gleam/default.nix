{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, git
, pkg-config
, openssl
, Security
, nix-update-script
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-buMnbBg+/vHXzbBuMPuV8AfdUmYA9J6WTXP7Oqrdo34=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.hostPlatform.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-0Vtf9UXLPW5HuqNIAGNyqIXCMTITdG7PuFdw4H4v6a4=";

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
