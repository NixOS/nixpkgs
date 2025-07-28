{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "udict";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lsmb";
    repo = "udict";
    rev = "v${version}";
    hash = "sha256-vcyzMw2tWil4MULEkf25S6kXzqMG6JXIx6GibxxspkY=";
  };

  cargoHash = "sha256-KlWzcJtNBTLCDDH01vI1mn9H7LUqni5o/Q6PsNeI7HE=";

  cargoPatches = [
    ./0001-update-version-in-lock-file.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Urban Dictionary CLI - written in Rust";
    homepage = "https://github.com/lsmb/udict";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "udict";
  };
}
