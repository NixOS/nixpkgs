{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watchlog";
  version = "1.259.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MjuQ1k38ZS1d6kJitEH9DTCUWzvUNhm3mto/QAWxE5k=";
  };

  cargoHash = "sha256-Mukw9DLIaPI0/CQws7AQwHmGmX/T4KuoX/2KTAUZXx4=";

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
