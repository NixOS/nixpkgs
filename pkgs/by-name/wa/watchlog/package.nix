{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchlog";
  version = "1.252.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZDT98pxtpoEenJPwz4Ws2kkTqJ0lTWvxv3LfjBsCvZo=";
  };

  cargoHash = "sha256-n1Pzuyf9EKHgvHqVlOO6bZNcD4KMHSh3jN9REtLulck=";

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
