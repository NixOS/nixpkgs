{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tagref";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "tagref";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-DjxRK3Ih58vzxvPM0YmRkFU4fogiFsI/WrdHyAonQ7A=";
  };

  cargoHash = "sha256-Pj86GQoIAf20F7z18Er7frX0aRacGNDQpeyUdr5kwz4=";

  meta = {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yusdacra ];
    platforms = lib.platforms.unix;
    mainProgram = "tagref";
  };
})
