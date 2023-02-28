{ lib, stdenv, rustPlatform, fetchFromGitHub, git, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NLUAKNWbKPAf81ce1OWTy/pnDcF2LfF12825DfE8AWw=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoSha256 = "sha256-IOZEdoQ5cqXjhgqNzOg4h5t8i3JDxfjamLFdesEy9Z8=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
