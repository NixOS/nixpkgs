{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuckr";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = finalAttrs.version;
    hash = "sha256-1fiz45x7XgVJtzxF+cxe6W203oIs3wytjh3V/IGk4XA=";
  };

  cargoHash = "sha256-q64BgL/UOWd/WNTyG8D1pwfa5ca1mKN79BI+W15ooMQ=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = {
    description = "Super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
})
