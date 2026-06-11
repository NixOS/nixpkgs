{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchlog";
  version = "1.261.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nv7J7/hg4t2f8ZBK7RCur6mbd+2Vn52QIz53ZFck96I=";
  };

  cargoHash = "sha256-672wSQ/bnwpT5USFtg4P7kZyn8ONOrHbZ4eRkNc6KBA=";

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
