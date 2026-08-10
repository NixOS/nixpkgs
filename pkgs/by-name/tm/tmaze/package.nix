{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tmaze";
  version = "1.18.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ur-fault";
    repo = "TMaze";
    tag = version;
    hash = "sha256-JB3ZFoC659TNaxoMWmzFFyvzdQZwmBDdsJHz79nRyn8=";
  };

  cargoHash = "sha256-srxk7+xAktUIkjve9aAruRdHqrglRlNjY+8S720w/M4=";

  # Upstream broke examples compilation in 1.18.0 due to API changes
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple multiplatform maze solving game for terminal";
    homepage = "https://github.com/ur-fault/TMaze";
    license = lib.licenses.unfree // {
      fullName = "Komarek's public license v1";
      url = "https://github.com/ur-fault/TMaze/blob/master/LICENSE";
    };
    maintainers = with lib.maintainers; [
      fkomarek
    ];
    mainProgram = "tmaze";
  };
}
