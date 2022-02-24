{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gtGb9Tt5SgNu0UgJwyhr+IFg7iEAnqzTC7cXf1l55b0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoSha256 = "sha256-oa0cqG0RKrKvQGOvi1lXecI4bqKXxWHdzwf+ARzTO2Q=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
