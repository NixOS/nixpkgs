{ lib, stdenv, rustPlatform, fetchFromGitHub, git, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XrXN+HZlCPzywFo10/vLHbz/zjglSZnNQKfYvLvx35I=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoHash = "sha256-K7MrrnupH1BS8KEIgVdlnGF91J5ND5umgdeLVCg7DbQ=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
