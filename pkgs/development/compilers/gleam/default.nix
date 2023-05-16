<<<<<<< HEAD
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
=======
{ lib, stdenv, rustPlatform, fetchFromGitHub, git, pkg-config, openssl, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.28.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-DOQhuSNIyP6K+M9a/uM8Cn6gyzpaH23+n4fux8otPWQ=";
=======
    hash = "sha256-3uHR6W2Vbqen9e6OXEFFl91/LzXCix4alnprFB36yes=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ git pkg-config ];

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ Security libiconv ];

<<<<<<< HEAD
  cargoHash = "sha256-CkMUconCw94Jvy7FhrOZvBbA8DAi91Ae5GFxGFBcEew=";

  passthru.updateScript = nix-update-script { };
=======
  cargoHash = "sha256-3+Jb/POABFIBkKpaTD9JDc1vrDzsJe9mGRBQR3UnDAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
