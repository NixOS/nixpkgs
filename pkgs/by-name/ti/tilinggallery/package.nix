{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tiling-gallery";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "roothch";
    repo = "TilingGallery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6AHNvizXitrdY/K13B/eVBCvdmfVou7Zv3tslHA4T8=";
  };

  cargoHash = "sha256-xr+gVDaxGtu7U/HaJoFXzNztvp+LNYAGuMqKA9QyXHg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for generating aperiodic tilings";
    longDescription = ''
      Tiling Gallery is a Rust-based CLI tool for generating SVG
      images of two types of aperiodic tilings:

      - Penrose tiling using the De Bruijn pentagrid method Pinwheel

      - tiling with recursive triangle subdivision

      This project is ideal for generating mathematical and artistic
      patterns based on non-periodic tilings.
    '';
    homepage = "https://github.com/roothch/TilingGallery";
    changelog = "https://github.com/roothch/TilingGallery/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tiling-gallery";
  };
})
