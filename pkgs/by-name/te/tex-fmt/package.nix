{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Atq/eyvdAuaUEeYDIC5D9icD44mcvuhsyuctYAPrBSU=";
  };

  cargoHash = "sha256-ShF2Z5Od/pgsNRM6WmxxFeE67pYZin1q4RR6nVmbrsA=";

  meta = {
    description = "LaTeX formatter written in Rust";
    homepage = "https://github.com/WGUNDERWOOD/tex-fmt";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
}
