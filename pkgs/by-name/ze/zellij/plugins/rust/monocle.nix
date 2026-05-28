{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "0.100.2";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LZQn4aXroYPpn6pMydo3R4mEcZpUm2m6CDSY4azrJlw=";
  };

  cargoHash = "sha256-pEskD/J8+zmd6wdGYeJdNlVtnU/2103z5FW3KTXB4Xk=";

  meta = {
    description = "Fuzzy find file names and contents in style";
    homepage = "https://github.com/imsnif/monocle";
    changelog = "https://github.com/imsnif/monocle/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
