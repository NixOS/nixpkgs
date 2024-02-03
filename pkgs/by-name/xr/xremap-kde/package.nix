{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xremap-kde";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "xremap";
    rev = "v${version}";
    hash = "sha256-GexVY76pfmHalJPiCfVe9C9CXtlojG/H6JjOiA0GF1c=";
  };

  cargoHash = "sha256-ABzt8PMsas9+NRvpgtZlsoYjjvwpU8f6lqhceHxq91M=";

  cargoBuildFlags = [
    "--features kde"
  ];

  meta = with lib; {
    description = "Key remapper for X11 and Wayland";
    homepage = "https://github.com/k0kubun/xremap";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mlyxshi ];
    mainProgram = "xremap";
  };
}
