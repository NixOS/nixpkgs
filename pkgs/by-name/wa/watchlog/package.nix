{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchlog";
  version = "1.244.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${version}";
    hash = "sha256-RQggLV4ROV9j5FxiJ2pRh/jlTFhgKUiBO/Gh/jLJ3tg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hdNEEbpsasAc8thQ6fKP4DQ+6jQiA2CO781Zz8CEiHU=";

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
