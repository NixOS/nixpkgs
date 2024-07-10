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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pwcvRj/ENbjLogMxk9AO+X2lqwMY+RjHUrBG/8RXLeo=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-e8Fo0LDo3zXT8wsWhDlnV8i8pRdaTlcSRiuAJvdZ4RI=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
}
