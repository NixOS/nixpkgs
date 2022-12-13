{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PzvFX1ssBPXhHBNGK38y427HYJ9Q40c4w2mqGZ/2rtI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoSha256 = "sha256-NeNpT/yOXE70ElawrOGBc4G5bN2ohzYVVUtF4yVCJOo=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
