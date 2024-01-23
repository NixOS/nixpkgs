{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  wayland,
  kdeSupport ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "xremap";
    rev = "v${version}";
    hash = "sha256-GexVY76pfmHalJPiCfVe9C9CXtlojG/H6JjOiA0GF1c=";
  };

  cargoHash = "sha256-ABzt8PMsas9+NRvpgtZlsoYjjvwpU8f6lqhceHxq91M=";

  cargoBuildFlags = lib.optional kdeSupport "--features kde";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    wayland
  ];

  meta = with lib; {
    description = "Key remapper for X11 and Wayland";
    homepage = "https://github.com/k0kubun/xremap";
    changelog = "https://github.com/k0kubun/xremap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "xremap";
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
