{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-o8TlD0qxz/0sS45tnBNXYNDzp+VAhH3Ym1odSleD/uw=";
  };

  cargoHash = "sha256-N3kCeBisjeOAG45QPQhplGRAvj5kebEX4U9pisM/GUQ=";

  meta = {
    description = "LaTeX formatter written in Rust";
    homepage = "https://github.com/WGUNDERWOOD/tex-fmt";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
}
