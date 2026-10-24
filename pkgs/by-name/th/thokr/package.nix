{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thokr";
  version = "0.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "thokr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NHkIQgNxNJ/BziVKfpPCI0oKyj2SoaRmixly+JONOD8=";
  };

  cargoHash = "sha256-S+uj6woCzf2KnYackXkNmwY91EmKmdUHOSSXYPqin2k=";

  meta = {
    description = "Typing tui with visualized results and historical logging";
    homepage = "https://github.com/jrnxf/thokr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "thokr";
  };
})
