{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ytsub";
  version = "0.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sarowish";
    repo = "ytsub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xuS9CvJziJ0DghW3chWzn+k8DEGFsYg2co52EjnN9iA=";
  };

  cargoHash = "sha256-jZ49S4uUoZJCyyIfvHQvrvzbtXSlfR2ZtoliSi72RNU=";

  buildInputs = [ sqlite ];

  meta = {
    description = "Subscriptions only TUI Youtube client";
    homepage = "https://github.com/sarowish/ytsub";
    changelog = "https://github.com/sarowish/ytsub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sarowish ];
    mainProgram = "ytsub";
  };
})
