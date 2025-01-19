{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "termsnap";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tomcur";
    repo = "termsnap";
    rev = "termsnap-v${version}";
    hash = "sha256-bYqhrMmgkEAiA1eiDbIOwH/PktwtIfxmYJRwDrFsNIc=";
  };

  cargoHash = "sha256-Q1FTVaFZzJJNQg6FDOaPpRCpPgw2EPQsnb8o6dSoVWw=";

  meta = {
    description = "Create SVGs from terminal output";
    homepage = "https://github.com/tomcur/termsnap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yash-garg ];
    mainProgram = "termsnap";
  };
}
