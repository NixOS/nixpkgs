{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thokr";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "thokr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CH3acyM4gLkOCYKyqXUEOTBF2BwU7DTmlSOfFLH63zU=";
  };

  cargoHash = "sha256-HvyCod3tRQmeXM02Lm9D/2Wf9MxwRZEt/jwPx/A5dVU=";

  meta = {
    description = "Typing tui with visualized results and historical logging";
    homepage = "https://github.com/jrnxf/thokr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "thokr";
  };
})
