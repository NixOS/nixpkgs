{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  pango,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
<<<<<<< HEAD
  pname = "wayscriber";
  version = "0.9.7";
=======
  name = "wayscriber";
  version = "0.7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "devmobasa";
    repo = "wayscriber";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-lPtgH4HaqBq7qQAgGUqbWiwaTSHXzPGuHe/PuMw0HmA=";
=======
    hash = "sha256-2CBSonwYa0lxhDYp1To08VicoNrAQkKwhJxZd0Iu+P0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libxkbcommon
  ];
<<<<<<< HEAD
  cargoHash = "sha256-rWUkWL1qPGzbAhRnOSX+A2RXWlfTbkFbKj3n8cHXk3c=";
=======
  cargoHash = "sha256-DjC8UOGSMqinr5p+Jzot7sRV1AP9xn4AwWXKRDZLdU4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ZoomIt-like screen annotation tool for Wayland compositors, written in Rust";
    homepage = "https://wayscriber.com";
    changelog = "https://github.com/devmobasa/wayscriber/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      leiserfg
    ];
    mainProgram = "wayscriber";
    platforms = lib.platforms.linux;
  };
})
