{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, git
, pkg-config
, openssl
, Security
, nix-update-script
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ncb95NjBH/Nk4XP2QIq66TgY1F7UaOaRIEvZchdo5Kw=";
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-6fbQOvmXWsU+6QiEHMNsbwuaIH9j0wzp0sNR7W8sBAE=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
}
