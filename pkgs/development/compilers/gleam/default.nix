{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NCLPatJWpvYKM+QdJB/Gfldlz5MQynWZB8o4x4cf5cA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-Tvb6QJubV8FS8UER++bEhst7Z0hVw42TCl+wOzZzi8Y=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
