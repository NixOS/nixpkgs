{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchlog";
  version = "1.263.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OGndYvlfuTVjOwWilWJINNNcBYNANHXxF+O7bdaoXp0=";
  };

  cargoHash = "sha256-fu7LQH75i/6xcAXMCM4YW8URku1MjnT18rBa+FUrNCw=";

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
