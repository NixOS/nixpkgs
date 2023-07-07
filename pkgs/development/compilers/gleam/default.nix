{ lib, stdenv, rustPlatform, fetchFromGitHub, git, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qGFF6Q1cY2hDb2TycB39RY7RAIJica0y6ju76NeIplY=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoHash = "sha256-/WIM7DhnfPlo/DGoTSEHON+et55h364V++VHU8Olvuc=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
