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
  version = "0.32.4";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xl75692d8h1uvh32pf+VJcXwQJwocxDaBNbfolHJKXU=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-SwG7cfoDYGyBu+1qF3+ynnw9rOA6jNExRV9uOVwgO60=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
