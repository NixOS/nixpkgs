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
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MLR7gY4NPb223NiPvTih88DQO2LvaYHsduWSH9QQa6M=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

  cargoHash = "sha256-I+5Vrpy5/9wFMB2dQYH9aqf/VonkDyIAyJmSHm5S6mk=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
