{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchlog";
  version = "1.248.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${version}";
    hash = "sha256-zi1tfndcjDoAT5IPj1ydjqeQyKAocR0O/jLeZTZAfO0=";
  };

  cargoHash = "sha256-/yUXaHGnhx/eOeXmAhLg9zWWHOuLGqbBBLjAJsB6JZw=";

  meta = {
    description = "Easier monitoring of live logs";
    homepage = "https://gitlab.com/kevincox/watchlog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kevincox ];

    # Dependency only supports Linux + Windows: https://github.com/mentaljam/standard_paths/tree/master/src
    platforms = with lib.platforms; linux ++ windows;
    mainProgram = "wl";
  };
}
