{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "volt";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "hqnna";
    repo = "volt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P14jLoONO3eFJ6DzHigAkZXZ++gcBHpJuK7+sVcBARM=";
  };

  cargoHash = "sha256-3E4fZRxB+kF4fW7WCl+sLkDaQt0Z0tgGfzixvSNZP1c=";

  meta = {
    description = "Ergonomic terminal settings editor for the Amp coding agent";
    homepage = "https://github.com/hqnna/volt";
    license = lib.licenses.blueOak100;
    maintainers = with lib.maintainers; [ qweered ];
    mainProgram = "volt";
  };
})
