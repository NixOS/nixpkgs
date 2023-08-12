{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, git
, pkg-config
, openssl
, Security
, libiconv
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.30.5";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DOQhuSNIyP6K+M9a/uM8Cn6gyzpaH23+n4fux8otPWQ=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoHash = "sha256-CkMUconCw94Jvy7FhrOZvBbA8DAi91Ae5GFxGFBcEew=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
