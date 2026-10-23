{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tagref";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "tagref";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vM7c9SPAiLn1WMHXBuXznhzd7dGVG28IxtvQtA0bOpg=";
  };

  cargoHash = "sha256-RqFMem/dC7kSmW84YuZ4oOqbOT3616/nworaMdTD/m0=";

  meta = {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yusdacra ];
    platforms = lib.platforms.unix;
    mainProgram = "tagref";
  };
})
