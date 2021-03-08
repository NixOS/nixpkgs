{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C56aM3FFnjtTQawQOnITVGXK5XSA/Pk7surt8MJHZK0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-AkkXV1cOM5YFvG5dUt7VarSzWyBZmvFMW08n1KqSAxY=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
