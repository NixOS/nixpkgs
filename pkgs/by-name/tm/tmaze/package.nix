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
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "ur-fault";
    repo = "TMaze";
    tag = version;
    hash = "sha256-wY9NaA1Gv2ghG9YiaIRKOSv3Oh+Zh6WN/ORuChM455Y=";
  };

  cargoHash = "sha256-4Shth+rpFLvZB2L00j6E/Zb6e6ZLbtDLpIrg20ei+u0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple multiplatform maze solving game for terminal";
    homepage = "https://github.com/ur-fault/TMaze";
    license = lib.licenses.free // {
      fullName = "Komarek's public license v1";
      url = "https://github.com/filip2cz/Komarek-s-Public-License/blob/v1.0/LICENSE-v1";
    };
    maintainers = with lib.maintainers; [
      fkomarek
    ];
    mainProgram = "tmaze";
  };
}
