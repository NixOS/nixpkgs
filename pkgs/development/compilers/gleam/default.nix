{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AK+eb0eJyI7ALn7sg0wz4GzHthxrJWd1PVT5bL9LKWA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoSha256 = "sha256-kFTAPbP42sbhsvP069ua0ys1Dw7W+Gdsv2YaGrzorIk=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
