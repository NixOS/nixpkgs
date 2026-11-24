{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchlog";
  version = "1.268.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wiE1BzosSVl+PeHclZXSM8Zl57HBOJa9j5lyJaq6yP4=";
  };

  cargoHash = "sha256-3U6d6I4Y6BXKOjC6nW4OOgCkp10+tpAeIIpYdEfgq8s=";

  meta = {
    description = "Easier monitoring of live logs";
    homepage = "https://gitlab.com/kevincox/watchlog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kevincox ];

    # Dependency only supports Linux + Windows: https://github.com/mentaljam/standard_paths/tree/master/src
    platforms = with lib.platforms; linux ++ windows;
    mainProgram = "wl";
  };
})
