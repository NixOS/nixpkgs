{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ujQ7emfGhzpRGeZ6RGZ57hFX4aIflTcwE9IEUMYb/ZI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-/SudEQynLkLl7Y731Uqm9AkEugTCnq4PFFRQcwz+qL8=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
