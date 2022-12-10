{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LLl3T7VvDyyeq47vgZPkQhcPk2yZMRsCta8EqduNvuY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoSha256 = "sha256-vMgU66LhhRrSA9Dx3eyVmUwrYKVtAfE12tQC8WzTimo=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
