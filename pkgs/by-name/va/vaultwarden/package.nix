{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  pkg-config,
  openssl,
  libiconv,
  dbBackend ? "sqlite",
  libmysqlclient,
  libpq,
}:

let
  webvault = callPackage ./webvault.nix { };
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
<<<<<<< HEAD
  version = "1.35.1";
=======
  version = "1.34.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-Lp3BDObJItscI1ifx8kFScSCaOajQMycYgGfpjVTL8I=";
  };

  cargoHash = "sha256-XqZOy84L6Spzd1NZf4CzZsdhDhrYNoQGToad4giFJR8=";
=======
    rev = version;
    hash = "sha256-Dj0ySVRvBZ/57+UHas3VI8bi/0JBRqn0IW1Dq+405J0=";
  };

  cargoHash = "sha256-4sDagd2XGamBz1XvDj4ycRVJ0F+4iwHOPlj/RglNDqE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # used for "Server Installed" version in admin panel
  env.VW_VERSION = version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optional (dbBackend == "mysql") libmysqlclient
  ++ lib.optional (dbBackend == "postgresql") libpq;

  buildFeatures = dbBackend;

  passthru = {
    inherit webvault;
    tests = nixosTests.vaultwarden;
    updateScript = callPackage ./update.nix { };
  };

  meta = {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    changelog = "https://github.com/dani-garcia/vaultwarden/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      SuperSandro2000
    ];
    mainProgram = "vaultwarden";
  };
}
